<?php
/**  
 * @desc make region to tiles
 */
namespace Libs;

use Coordconverter;
use Point;

class RegionTiles
{
    // storage key for point
    const KEY_LONGITUDE = 0;
    const KEY_LATITUDE = 1;
    // point in region or not const
    const P_OUT_REGION = 0; // out
    const P_IN_REGION = 1; // in
    const P_EDGE_REGION = 2; //edge
    // scores [tile in/out/include ... region]
    const T_OUT_REGION = 0;
    // const T_REGION_THRESHOLD_EDGE = 5;
    const T_REGION_THRESHOLD = 10;
    const T_ONE_POINT_IN_REGION = 20;
    const T_TOUCHED_BY_REGION = 30;
    const T_TWO_POINT_IN_REGION = 40;
    const T_ACROSS_BY_REGION = 50;
    const T_THREE_POINT_IN_REGION = 70;
    const T_INCLUDE_REGION = 80;
    const T_FOUR_POINT_IN_REGION = 100;
    // batch save count
    const SAVE_BATCH_COUNT = 100;
    const SAVE_EXT_BATCH_COUNT = 800;
    // pak mid fix
    const PAK_MIDFIX = '_';
    // precision of tiles
    private $_precision = 1000;
    private $_threshold = 0;
    // callback
    private $_cb_tiles_proc = null;
    private $_cb_points_proc = null;
    private $_cb_ext_tiles_proc = null;  // threshold tiles callback

    /**
     * set precision
     */
    public function set_precision($precision)
    {
        $this->_precision = $precision;
        return $this;
    }
    /**
     * set threshold
     */
    public function set_threshold($threshold)
    {
        $this->_threshold = $threshold;
        return $this;
    }
    public function set_tiles_proc_callback($callback)
    {
        $this->_cb_tiles_proc = $callback;
        return $this;
    }
    public function set_points_proc_callback($callback)
    {
        $this->_cb_points_proc = $callback;
        return $this;
    }
    public function set_threshold_tiles_proc($callback)
    {
        $this->_cb_ext_tiles_proc = $callback;
        return $this;
    }
    /**
     * get tile of point
     */
    public function get_tile($longitude, $latitude)
    {
        $tile_x = floor($longitude / $this->_precision);
        $tile_y = floor($latitude / $this->_precision);
        return [$tile_x, $tile_y];
    }
    /**
     * get apex of tile
     */
    public function get_apex_of_tile($tile)
    {
        $x = $tile[0] * $this->_precision;
        $y = $tile[1] * $this->_precision;
        return [$x, $x + $this->_precision, $y, $y + $this->_precision];
    }

    public function get_midpoint_of_tile($tile)
    {
        $x = $tile[0] * $this->_precision;
        $y = $tile[1] * $this->_precision;
        return [
            $x + $this->_precision/2,
            $y + $this->_precision/2
        ];
    }

    function region_2_tiles_map($region)
    {
        
        $_r = array_pop($region);
        $left = $right = $_r[self::KEY_LONGITUDE];
        $top = $bottom = $_r[self::KEY_LATITUDE];
        foreach ($region as $_r) {
            $_r[self::KEY_LONGITUDE] < $left
                && $left = $_r[self::KEY_LONGITUDE];
            $_r[self::KEY_LONGITUDE] > $right
                && $right = $_r[self::KEY_LONGITUDE];
            $_r[self::KEY_LATITUDE] > $top
                && $top = $_r[self::KEY_LATITUDE];
            $_r[self::KEY_LATITUDE] < $bottom
                && $bottom = $_r[self::KEY_LATITUDE];
        }
        $map = new \stdClass();
        $map->bottom = floor($bottom / $this->_precision);
        $map->top = floor($top / $this->_precision);
        $map->left = floor($left / $this->_precision);
        $map->right = floor($right / $this->_precision);
        return $map;
    }

    function tintage_tiles($region)
    {
        $result = true;
        $tiles_total = 0;
        $point_arr = [];
        $tile_arr = [];
        $point_storage_cache = [];
        $map = $this->region_2_tiles_map($region);
        if (
            $map->top == $map->bottom
            && $map->right == $map->left
        ) {
            // tile include the region
            $tile_arr = [
                self::_pak($map->left, $map->bottom) => self::T_INCLUDE_REGION
            ];
            $ext_tiles = $this->_get_ext_tiles($map->left, $map->bottom);
            $tiles_proc = call_user_func($this->_cb_tiles_proc, $tile_arr);
            $ext_tiles_proc = call_user_func($this->_cb_ext_tiles_proc, $ext_tiles);
            return $tiles_proc;
        }
        $ext_tiles = [];
        // tile(l, r, b, t)
        // point: (l, b) (l, t) (r, b) (r, t)
        for ($x = $map->left; $x <= $map->right; $x++) {
            for ($y = $map->bottom; $y <= $map->top; $y++) {
                $t_left_x = $x * $this->_precision;
                $t_bottom_y = $y * $this->_precision;
                $t_right_x = $t_left_x + $this->_precision;
                $t_top_y = $t_bottom_y + $this->_precision;
                // point left bottom
                $point_lb = self::P_OUT_REGION;
                $_key = self::_pak($t_left_x, $t_bottom_y);
                if (isset($point_arr[$_key])) {
                    $point_lb = $point_arr[$_key];
                    // this point will not be used any more
                    unset($point_arr[$_key]);
                } else {
                    $point_lb
                        = self::point_in_region($t_left_x, $t_bottom_y, $region);
                }
                // point left top
                $point_lt = self::P_OUT_REGION;
                $_key = self::_pak($t_left_x, $t_top_y);
                if (isset($point_arr[$_key])) {
                    $point_lt = $point_arr[$_key];
                } else {
                    $point_arr[$_key]
                        = $point_lt
                        = self::point_in_region($t_left_x, $t_top_y, $region);
                }
                // point right bottom
                $point_rb = self::P_OUT_REGION;
                $_key = self::_pak($t_right_x, $t_bottom_y);
                if (isset($point_arr[$_key])) {
                    $point_rb = $point_arr[$_key];
                } else {
                    $point_arr[$_key]
                        = $point_rb
                        = self::point_in_region($t_right_x, $t_bottom_y, $region);
                }
                // point right top
                $point_rt = self::P_OUT_REGION;
                $_key = self::_pak($t_right_x, $t_top_y);
                if (isset($point_arr[$_key])) {
                    $point_rt = $point_arr[$_key];
                } else {
                    $point_arr[$_key]
                        = $point_rt
                        = self::point_in_region($t_right_x, $t_top_y, $region);
                }
                // point storage cache
                $point_lb == self::P_OUT_REGION
                          || $point_storage_cache[self::_pak($t_left_x, $t_bottom_y)] = $point_lb;
                $point_lt == self::P_OUT_REGION
                          || $point_storage_cache[self::_pak($t_left_x, $t_top_y)] = $point_lt;
                $point_rb == self::P_OUT_REGION
                          || $point_storage_cache[self::_pak($t_right_x, $t_bottom_y)] = $point_rb;
                $point_rt == self::P_OUT_REGION
                          || $point_storage_cache[self::_pak($t_right_x, $t_top_y)] = $point_rt;
                // tile in region or not
                $score = self::T_OUT_REGION;
                $tio = 0;
                $point_lb == self::P_IN_REGION && $tio++;
                $point_lt == self::P_IN_REGION && $tio++;
                $point_rb == self::P_IN_REGION && $tio++;
                $point_rt == self::P_IN_REGION && $tio++;
                // CH::p($t_left_x, $t_bottom_y, $point_lb, $point_lt, $point_rb, $point_rt);
                $edge_count = 0;
                $point_lb == self::P_EDGE_REGION && $edge_count++;
                $point_lt == self::P_EDGE_REGION && $edge_count++;
                $point_rb == self::P_EDGE_REGION && $edge_count++;
                $point_rt == self::P_EDGE_REGION && $edge_count++;
                ///
                // begion mark score
                ///
                if ($tio > 0 && $edge_count > 0) {
                    // tiles points in region
                    $tio += $edge_count;
                } else if ($tio == 0 && $edge_count > 1) {
                    // if all point at edge of region
                    // and point counts > 1
                    $t_mid_x = $t_left_x + $this->_precision / 2;
                    $t_mid_y = $t_bottom_y + $this->_precision / 2;
                    $point_mid = self::point_in_region($t_mid_x, $t_mid_y, $region);
                    if ($point_mid != self::P_OUT_REGION) {
                        $tio = $edge_count;
                    } else {
                        $t_left_plus_x = $t_left_x + 1;
                        $t_bottom_plus_y = $t_bottom_y + 1;
                        $t_right_minus_x = $t_right_x - 1;
                        $t_top_minus_y = $t_top_y - 1;
                        self::point_in_region($t_left_plus_x, $t_bottom_plus_y, $region)
                            == self::P_OUT_REGION
                            || $tio = $edge_count;
                        self::point_in_region($t_left_plus_x, $t_top_minus_y, $region)
                            == self::P_OUT_REGION
                            || $tio = $edge_count;
                        self::point_in_region($t_right_minus_x, $t_top_minus_y, $region)
                            == self::P_OUT_REGION
                            || $tio = $edge_count;
                        self::point_in_region($t_right_minus_x, $t_bottom_plus_y, $region)
                            == self::P_OUT_REGION
                            || $tio = $edge_count;
                    }
                } else {
                    // check across possibility
                    $intersection_count = self::_region_tile_intersection(
                        $t_left_x, $t_right_x,
                        $t_bottom_y, $t_top_y,
                        $region
                    );
                    if ($intersection_count > 1) {
                        $score = $intersection_count > 3
                               ? self::T_ACROSS_BY_REGION
                               : self::T_TOUCHED_BY_REGION;
                    }
                }
                if ($tio > 0) {
                    switch ($tio) {
                    case 1:
                        $score = self::T_ONE_POINT_IN_REGION;
                        break;
                    case 2:
                        $score = self::T_TWO_POINT_IN_REGION;
                        break;
                    case 3:
                        $score = self::T_THREE_POINT_IN_REGION;
                        break;
                    case 4:
                        $score = self::T_FOUR_POINT_IN_REGION;
                        break;
                    }
                }
                if ($score !== self::T_OUT_REGION) {
                    $tile_arr[self::_pak($x, $y)] = $score;
                    $tiles_total++;
                }
                if  (
                    $score !== self::T_FOUR_POINT_IN_REGION
                    || $edge_count > 2
                ) {
                    $_arr_ext_tiles = $this->_get_ext_tiles($x, $y);
                    foreach ($_arr_ext_tiles as $__aet => $__aet_score) {
                        $ext_tiles[$__aet] = isset($ext_tiles[$__aet])
                                           ? self::max($ext_tiles[$__aet], $__aet_score)
                                           : $__aet_score;
                    }
                }
                if (count($tile_arr) >= self::SAVE_BATCH_COUNT) {
                    $tiles_proc = $this->_cb_tiles_proc === null
                                ? true
                                : call_user_func($this->_cb_tiles_proc, $tile_arr);
                    $points_proc = $this->_cb_points_proc === null
                                 ? true
                                 : call_user_func($this->_cb_points_proc, $point_storage_cache);
                    $result = $result && $tiles_proc && $points_proc;
                    $tile_arr = [];
                    $point_storage_cache = [];
                }
                if (count($ext_tiles) >= self::SAVE_EXT_BATCH_COUNT) {
                    call_user_func($this->_cb_ext_tiles_proc, $ext_tiles);
                    $ext_tiles = [];
                }
            }
        }
        if (count($tile_arr) > 0) {
            $tiles_proc = $this->_cb_tiles_proc === null
                        ? true
                        : call_user_func($this->_cb_tiles_proc, $tile_arr);
            $points_proc = $this->_cb_points_proc === null
                         ? true
                         : call_user_func($this->_cb_points_proc, $point_storage_cache);
            $result = $result && $tiles_proc && $points_proc;
            $tile_arr = [];
            $point_storage_cache = [];
        }
        if (count($ext_tiles) > 0) {
            call_user_func($this->_cb_ext_tiles_proc, $ext_tiles);
            $ext_tiles = [];
        }
        // no region tintage out
        $tiles_total == 0 && $result = false;
        return $result;
    }
    /**
     * check point in region or not
     *
     * |\      /\        /|
     * | \    /  \      / |
     * |  \  /    \   /   |
     * .--------。  _     |
     * |                  |
     * |                  |
     * |__________________|
     *
     * make parallel x line from point to y line
     * check intersection counts
     *
     * @param longitude
     * @param latitude
     * @param point array of region
     * @return 0: not in; 1: in; 2:intersection
     */
    static function point_in_region($x, $y, $region)
    {
        $pre_x = null;
        $pre_y = null;
        $inter_point_count = 0;
        $is_edge = false;
        // make points to a region
        $first_point = $region[0];
        array_push($region, $first_point);
        // checking begion
        foreach ($region as $_r) {
            if ($pre_x === null || $pre_y === null) {
                $pre_x = $_r[self::KEY_LONGITUDE];
                $pre_y = $_r[self::KEY_LATITUDE];
                continue;
            }
            $cx = $_r[0];
            $cy = $_r[1];
            // check edge
            // three point in a parellel line of x
            if ($pre_y == $y
                && $cy == $y
                && (
                    ($pre_x >= $x && $cx <= $x)
                    || ($cx >= $x && $pre_x <= $x)
                )) {
                $is_edge = true;
                break;
            }
            // check intersection count of shadow line
            if (
                ($pre_y < $y && $cy >= $y)
                || ($cy < $y && $pre_y >= $y)
            ) {
                // straight line formula of two point
                // know value y, check value x
                $the_x = ($pre_x - $cx) * ($y - $cy) / ($pre_y - $cy) + $cx;
                if ($the_x < $x) {
                    $inter_point_count++;
                }
                if ($the_x == $x) {
                    $is_edge = true;
                    break;
                }
            }
            $pre_x = $cx;
            $pre_y = $cy;
        }
        if ($is_edge) {
            return self::P_EDGE_REGION;
        }
        if ($inter_point_count % 2 == 0) {
            return self::P_OUT_REGION;
        }
        return self::P_IN_REGION;
    }
    /**
     * 求最小值
     */ 
    static function min($x1, $x2)
    {
        return $x1 < $x2 ? $x1 : $x2;
    }
    /**
     * 求最大值
     */ 
    static function max($x1, $x2)
    {
        return $x1 > $x2 ? $x1 : $x2;
    }
    /**
     * 排斥实验
     */
    static function is_rect_cross($p1, $p2, $q1, $q2)
    {
        return (min($p1->x, $p2->x) <= max($q1->x, $q2->x))
                                     && (min($q1->x, $q2->x) <= max($p1->x, $p2->x))
                                     && (min($p1->y, $p2->y) <= max($q1->y, $q2->y))
                                     && (min($q1->y, $q2->y) <= max($p1->y, $p2->y));
    }
    /**
     * 向量
     */
    static function make_vector($p1, $p2)
    {
        $v = new \stdClass();
        $v->x = $p1->x - $p2->x;
        $v->y = $p1->y - $p2->y;
        return $v;
    }
    /**
     * 点
     */
    static function make_point($x, $y)
    {
        $p = new \stdClass();
        $p->x = $x;
        $p->y = $y;
        return $p;
    }
    /**
     * 求叉积
     */ 
    static function cross_product($a, $b)
    {
        return $a->x * $b->y - $a->y * $b->x;
    }
    /**
     * 跨立实验
     * 此处不检测两线平行情况
     */
    static function is_line_segment_cross($a1, $b1, $a2, $b2)
    {
        // first check
        $a2a1 = self::make_vector($a2, $a1);
        $b2a1 = self::make_vector($b2, $a1);
        $b1a1 = self::make_vector($b1, $a1);
        $fc1 = self::cross_product($a2a1, $b1a1);
        $fc2 = self::cross_product($b1a1, $b2a1);
        if (($fc1 ^ $fc2) <= 0) {
            return false;
        }
        // second check
        $b2a2 = self::make_vector($b2, $a2);
        $a1a2 = self::make_vector($a1, $a2);
        $b1a2 = self::make_vector($b1, $a2);
        $sc1 = self::cross_product($a1a2, $b2a2);
        $sc2 = self::cross_product($b2a2, $b1a2);
        if (($sc1 ^ $sc2) <= 0) {
            return false;
        }
        return true;
    }
    /**
     * check region and tile intersection
     * @param double: tile left x
     * @param double: tile right x
     * @param double: tile bottom y
     * @param double: tile top y
     * @param array: region points
     * @return int: intersection count
     */
    private function _region_tile_intersection($tile_lx, $tile_rx, $tile_by, $tile_ty, $region)
    {
        $inter_count = 0;
        $rp_pre = null;
        // make points to a region
        $first_point = $region[0];
        array_push($region, $first_point);
        // checking begion
        foreach ($region as $_r) {
            $_x = $_r[self::KEY_LONGITUDE];
            $_y = $_r[self::KEY_LATITUDE];
            if ($rp_pre === null) {
                $rp_pre = self::make_point($_x, $_y);
                continue;
            }
            // tile points
            $tp1 = self::make_point($tile_lx, $tile_by);
            $tp2 = self::make_point($tile_rx, $tile_by);
            $tp3 = self::make_point($tile_rx, $tile_ty);
            $tp4 = self::make_point($tile_lx, $tile_ty);
            // region points
            $rp_current = self::make_point($_x, $_y);
            foreach (
                [[$tp1, $tp2], [$tp2, $tp3], [$tp3, $tp4], [$tp4, $tp1]]
                as $_tp
            ) {
                if (
                    self::is_rect_cross($_tp[0], $_tp[1], $rp_pre, $rp_current)
                    && self::is_line_segment_cross($_tp[0], $_tp[1], $rp_pre, $rp_current)
                ) {
                    $inter_count++;
                }
            }
        }
        return $inter_count;
    }

    private function _get_ext_tiles($tile_x, $tile_y)
    {
        $t_left_x = $tile_x * $this->_precision;
        $t_bottom_y = $tile_y * $this->_precision;
        $t_right_x = $t_left_x + $this->_precision;
        $t_top_y = $t_bottom_y + $this->_precision;
        $p_left_bottom = Coordconverter::convertMC2LL([$t_left_x, $t_bottom_y]);
        $p_left_top = Coordconverter::convertMC2LL([$t_left_x, $t_top_y]);
        $p_left_bottom = [
            'longitude' => $p_left_bottom[0],
            'latitude' => $p_left_bottom[1],
        ];
        $p_left_top = [
            'longitude' => $p_left_top[0],
            'latitude' => $p_left_top[1],
        ];
        $distance = Point::di($p_left_bottom, $p_left_top);
        // check threshold
        if ($this->_threshold < $distance) {
            return [];
        }
        $p_mid_x = $t_left_x + $this->_precision / 2;
        $p_mid_y = $t_bottom_y + $this->_precision / 2;
        $p_mid = Coordconverter::convertMC2LL([$p_mid_x, $p_mid_y]);
        $step = floor($this->_threshold / $distance);
        $ext_tiles = [];
        for ($i = $step; $i >= 0; $i--) {
            $_x_pass = false;
            for ($j = $step; $j >= 0; $j--) {
                if ($i == 0 && $j == 0) {
                    continue;
                }
                if ($_x_pass) {
                    $ext_tiles[self::_pak($tile_x + $i, $tile_y + $j)] = self::T_REGION_THRESHOLD;
                    $ext_tiles[self::_pak($tile_x + $i, $tile_y - $j)] = self::T_REGION_THRESHOLD;
                    $ext_tiles[self::_pak($tile_x - $i, $tile_y + $j)] = self::T_REGION_THRESHOLD;
                    $ext_tiles[self::_pak($tile_x - $i, $tile_y - $j)] = self::T_REGION_THRESHOLD;
                    continue;
                }
                $__t_x = $tile_x + $i;
                $__t_y = $tile_y + $j;
                $__p_mid_x = ($__t_x + 0.5) * $this->_precision;
                $__p_mid_y = ($__t_y + 0.5) * $this->_precision;
                $__p_mid = Coordconverter::convertMC2LL([$__p_mid_x, $__p_mid_y]);
                $__dis = Point::di(
                    ['longitude' => $p_mid[0], 'latitude' => $p_mid[1]],
                    ['longitude' => $__p_mid[0], 'latitude' => $__p_mid[1]]
                );
                if ($__dis <= $this->_threshold) {
                    // $ext_tiles[self::_pak($tile_x + $i, $tile_y + $j)] = self::T_REGION_THRESHOLD_EDGE;
                    // $ext_tiles[self::_pak($tile_x + $i, $tile_y - $j)] = self::T_REGION_THRESHOLD_EDGE;
                    // $ext_tiles[self::_pak($tile_x - $i, $tile_y + $j)] = self::T_REGION_THRESHOLD_EDGE;
                    // $ext_tiles[self::_pak($tile_x - $i, $tile_y - $j)] = self::T_REGION_THRESHOLD_EDGE;
                    $_x_pass = true;
                }
            }
        }
        return $ext_tiles;
    }
    /**
     * point array key convert
     */
    private static function _pak($x, $y)
    {
        return strval($x) . self::PAK_MIDFIX . strval($y);
    }
    static function unpak($key)
    {
        return explode(self::PAK_MIDFIX, $key);
    }

}