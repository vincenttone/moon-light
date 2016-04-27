<?php
namespace Libs;

class Coordconverter {
    private static $MCBAND = array(12890594.86,8362377.87,5591021,3481989.83,1678043.12,0);
    private static $LLBAND = array(75,60,45,30,15,0);

    private static $MC2LL = array(array(1.410526172116255e-008,8.983055096488720e-006,-1.99398338163310,2.009824383106796e+002,-1.872403703815547e+002,91.60875166698430,-23.38765649603339,2.57121317296198,-0.03801003308653,1.733798120000000e+007),array(-7.435856389565537e-009,8.983055097726239e-006,-0.78625201886289,96.32687599759846,-1.85204757529826,-59.36935905485877,47.40033549296737,-16.50741931063887,2.28786674699375,1.026014486000000e+007),array(-3.030883460898826e-008,8.983055099835780e-006,0.30071316287616,59.74293618442277,7.35798407487100,-25.38371002664745,13.45380521110908,-3.29883767235584,0.32710905363475,6.856817370000000e+006),array(-1.981981304930552e-008,8.983055099779535e-006,0.03278182852591,40.31678527705744,0.65659298677277,-4.44255534477492,0.85341911805263,0.12923347998204,-0.04625736007561,4.482777060000000e+006),array(3.091913710684370e-009,8.983055096812155e-006,0.00006995724062,23.10934304144901,-0.00023663490511,-0.63218178102420,-0.00663494467273,0.03430082397953,-0.00466043876332,2.555164400000000e+006),array(2.890871144776878e-009,8.983055095805407e-006,-0.00000003068298,7.47137025468032,-0.00000353937994,-0.02145144861037,-0.00001234426596,0.00010322952773,-0.00000323890364,8.260885000000000e+005));

    private static $LL2MC = array(array(-0.00157021024440, 1.113207020616939e+005, 1.704480524535203e+015, -1.033898737604234e+016, 2.611266785660388e+016,-3.514966917665370e+016,2.659570071840392e+016,-1.072501245418824e+016,
               1.800819912950474e+015,82.5),
              array(8.277824516172526e-004,1.113207020463578e+005,6.477955746671608e+008,-4.082003173641316e+009,
               1.077490566351142e+010,-1.517187553151559e+010,1.205306533862167e+010,-5.124939663577472e+009,
               9.133119359512032e+008,67.5),
              array(0.00337398766765,1.113207020202162e+005,4.481351045890365e+006,-2.339375119931662e+007,
               7.968221547186455e+007,-1.159649932797253e+008,9.723671115602145e+007,-4.366194633752821e+007,
               8.477230501135234e+006,52.5),
              array(0.00220636496208,1.113207020209128e+005,5.175186112841131e+004,3.796837749470245e+006,9.920137397791013e+005,
               -1.221952217112870e+006,1.340652697009075e+006,-6.209436990984312e+005,1.444169293806241e+005,37.5),
              array(-3.441963504368392e-004,1.113207020576856e+005,2.782353980772752e+002,2.485758690035394e+006,6.070750963243378e+003,
               5.482118345352118e+004,9.540606633304236e+003,-2.710553267466450e+003,1.405483844121726e+003,22.5),
              array(-3.218135878613132e-004,1.113207020701615e+005,0.00369383431289,8.237256402795718e+005,0.46104986909093,
               2.351343141331292e+003,1.58060784298199,8.77738589078284,0.37238884252424,7.45));

    /**
     * 将经纬度坐标转化为墨卡托坐标
     * $point: 经纬度坐标
     */
    public static function convertLL2MC($point) {
        //$point是数组类型，$point[0]是lng, $point[1]是lat
        $temp = null;
        $factor = null;
        $point[0] = self::getLoop($point[0], -180, 180);
        $point[1] = self::getRange($point[1], -74, 74);
        $temp = $point;
        $cnt = count(self::$LLBAND);
        for($i = 0; $i < $cnt; $i++){
          if($temp[1] >= self::$LLBAND[$i]){
            $factor = self::$LL2MC[$i];
            break;
          }
        }

        if(!$factor){//南半球坐标
          for($i = $cnt - 1; $i >= 0; $i--){
            if($temp[1] <= - self::$LLBAND[$i]){
              $factor = self::$LL2MC[$i];
              break;
            }
          }
        }

        $mc = self::convertor($point, $factor);
        $fmtMc = array(round($mc[0], 2), round($mc[1], 2));//保留2位小数
        return $fmtMc; //数组
    }

    /**
     * 将墨卡托坐标转化为经纬度坐标
     * $point: 墨卡托坐标
     */
    public static function convertMC2LL($point) {
        $temp = null;
        $factor = null;
        $temp = array(abs($point[0]), abs($point[1]));
        $cnt = count(self::$MCBAND);
        for ($i = 0; $i < $cnt; $i++){
          if ($temp[1] >= self::$MCBAND[$i]){
            $factor = self::$MC2LL[$i];
            break;
          }
        }
        $arrTemp = self::convertor($point, $factor);
        $lng = round($arrTemp[0], 6);
        $lat = round($arrTemp[1], 6);

        $ll = array($lng, $lat);
        return $ll;
    }

    //计算两点之间的距离
    //pointA为基准点,需要通过pointA来计算纬度
    public static function getDistance($pointA, $pointB) {

        $distance = sqrt(pow(($pointA[0]-$pointB[0]), 2)+pow(($pointA[1]-$pointB[1]), 2));
        $mcllPoint = self::convertMC2LL($pointA);
        if (empty($mcllPoint[1])) {
            return null;
        }
        $distance *= cos(deg2rad($mcllPoint[1]));
        return $distance;
    }

    public static function insidePolyGen($lng, $lat, $deliver_region) {
        if (!isset($lng) ||
            !isset($lat) ||
            count($deliver_region) < 3) {
            return false;
        }

        $n_cross = 0;
        for ($i = 0; $i < count($deliver_region); $i++) {
            $p1 = $deliver_region[$i];
            $p2 = $deliver_region[($i+1) % count($deliver_region)];

            if (bccomp($p1['latitude'], $p2['latitude'], 6) == 0) {
                continue;
            }

            if (($lat < $p1['latitude'] && $lat < $p2['latitude']) ||
                ($lat > $p1['latitude'] && $lat > $p2['latitude'])) {
                continue;
            }

            $cross_lng = $p1['longitude'] + ($lat - $p1['latitude']) * ($p2['longitude'] - $p1['longitude']) / ($p2['latitude'] - $p1['latitude']);
            if ($cross_lng < $lng) {
                $n_cross++;
            }
        }
        return ($n_cross % 2 == 1);
    }

    private static function convertor($fromPoint, $factor) {
        if (!$fromPoint || !$factor) {
          return;
        }

        $x = $factor[0] + $factor[1] * abs($fromPoint[0]);
        $temp = abs($fromPoint[1]) / $factor[9];
        $y = $factor[2] +
                $factor[3] * $temp +
                $factor[4] * $temp * $temp +
                $factor[5] * $temp * $temp * $temp +
                $factor[6] * $temp * $temp * $temp * $temp +
                $factor[7] * $temp * $temp * $temp * $temp * $temp +
                $factor[8] * $temp * $temp * $temp * $temp * $temp * $temp;

        $x *= ($fromPoint[0] < 0 ? -1 : 1);
        $y *= ($fromPoint[1] < 0 ? -1 : 1);

        return array($x, $y);
    }

    private static function getRange($v, $a, $b) {
        if($a != null){
          $v = max($v, $a);
        }

        if($b != null){
          $v = min($v, $b);
        }
        return $v;
    }

    private static function getLoop($v, $a, $b) {
        while($v > $b){
          $v -= $b - $a;
        }

        while($v < $a){
          $v += $b - $a;
        }

        return $v;
    }

    public static function descCircular($centre, $radius, $num = 8)
    {
        if ((empty($radius)) || (empty($centre)) || (intval($num) < 3))
        {
            return false;
        }

        //$centre = self::convertMC2LL(array('0' => $centre['longitude'], '1' => $centre['latitude']));
        $angle = ceil(360/$num);
        $tmp = 0;
        $poly = array();

        for (; ;)
        {
            $tmp += $angle;
            if ($tmp >= 360)
            {
                break;
            }

            /*
            $point = self::convertLL2MC(array('0' => ($radius * sin($tmp)) + $centre[0],
                                              '1' => ($radius * cos($tmp)) + $centre[1]));

            $poly = array('longitude' => $point[0], 'latitude' => $point[1]);
            */
            $poly[] = array('longitude' => ($radius * sin($tmp)) + $centre['longitude'],
                            'latitude' => ($radius * cos($tmp)) + $centre['latitude']);
        }

        return $poly;
    }

    private static function isRectCross($p1, $p2, $q1, $q2)
    {
        return ((min($p1['latitude'], $p2['latitude']) <= max($q1['latitude'], $q2['latitude'])) &&
                (min($q1['latitude'], $q2['latitude']) <= max($p1['latitude'], $p2['latitude'])) &&
                (min($p1['longitude'], $p2['longitude']) <= max($q1['longitude'], $q2['longitude'])) &&
                (min($q1['longitude'], $q2['longitude']) <= max($p1['longitude'], $p2['longitude'])));
    }

    private static function isLineCross($p1, $p2, $q1, $q2)
    {
        $line1 = $p1['latitude'] * ($q1['longitude'] - $p2['longitude']) +
                 $p2['latitude'] * ($p1['longitude'] - $q1['longitude']) +
                 $q1['latitude'] * ($p2['longitude'] - $p1['longitude']);
        $line2 = $p1['latitude'] * ($q2['longitude'] - $p2['longitude']) +
                 $p2['latitude'] * ($p1['longitude'] - $q2['longitude']) +
                 $q2['latitude'] * ($p2['longitude'] - $p1['longitude']);
        if ((($line1 ^ $line2) >= 0) && !($line1 == 0 && $line2 == 0))
        {
            return false;
        }

        $line1 = $q1['latitude'] * ($p1['longitude'] - $q2['longitude']) +
                 $q2['latitude'] * ($q1['longitude'] - $p1['longitude']) +
                 $p1['latitude'] * ($q2['longitude'] - $q1['longitude']);
        $line2 = $q1['latitude'] * ($p2['longitude'] - $q2['longitude']) +
                 $q2['latitude'] * ($q1['longitude'] - $p2['longitude']) +
                 $p2['latitude'] * ($q2['longitude'] - $q1['longitude']);
        if ((($line1 ^ $line2) >= 0) && !($line1 == 0 && $line2 == 0))
        {
            return false;
        }

        return true;
    }

    private static function crossPoint($p1, $p2, $q1, $q2)
    {
        return array
        (
            'longitude' => (($p1['latitude'] - $q1['latitude']) * ($p2['longitude'] - $p1['longitude']) * ($q2['longitude'] - $q1['longitude']) + $q1['longitude'] * ($q2['latitude'] - $q1['latitude']) * ($p2['longitude'] - $p1['longitude']) - $p1['longitude'] * ($p2['latitude'] - $p1['latitude']) * ($q2['longitude'] - $q1['longitude'])) / (($q2['longitude'] - $q1['longitude']) * ($p1['latitude'] - $p2['latitude']) - ($p2['longitude'] - $p1['longitude']) * ($q1['latitude'] - $q2['latitude'])),
             'latitude' => ($p2['latitude'] * ($p1['longitude'] - $p2['longitude']) * ($q2['latitude'] - $q1['latitude']) + ($q2['longitude']- $p2['longitude']) * ($q2['latitude'] - $q1['latitude']) * ($p1['latitude'] - $p2['latitude']) - $q2['latitude'] * ($q1['longitude'] - $q2['longitude']) * ($p2['latitude'] - $p1['latitude'])) / (($p1['longitude'] - $p2['longitude']) * ($q2['latitude'] - $q1['latitude']) - ($p2['latitude'] - $p1['latitude']) * ($q1['longitude'] - $q2['longitude']))
        );
    }

    private static function isPointInPolygon($polygon, $point)
    {
        $c = false;
        $polygon_count = count($polygon);

        for ($i = 0, $j = $polygon_count - 1; $i < $polygon_count; $j = $i++)
        {
            if (((($polygon[$i]['longitude'] <= $point['longitude']) && ($point['longitude'] < $polygon[$j]['longitude'])) ||
                (($polygon[$j]['longitude'] <= $point['longitude']) && ($point['longitude'] < $polygon[$i]['longitude']))) &&
                ($point['latitude'] < ($polygon[$j]['latitude'] - $polygon[$i]['latitude']) * ($point['longitude'] - $polygon[$i]['longitude']) / ($polygon[$j]['longitude'] - $polygon[$i]['longitude']) + $polygon[$i]['latitude']))
            {
               $c = !$c;
            }
        }

        return $c;
    }

    private static function pointCmp($p1, $p2, $point)
    {
        if ($p1['latitude'] >= 0 && $p2['latitude'] < 0)
        {
            return true;
        }

        if ($p1['latitude'] == 0 && $p2['latitude'] == 0)
        {
            return $p1['longitude'] > $p2['longitude'];
        }

        $det = (($p1['latitude'] - $point['latitude']) * ($p2['longitude'] - $point['longitude'])) -
               (($p2['latitude'] - $point['latitude']) * ($p1['longitude'] - $point['longitude']));

        if ($det < 0)
        {
            return true;
        }

        if ($det > 0)
        {
            return false;
        }

        return (($p1['latitude'] - $point['latitude']) * ($p1['latitude'] - $point['latitude']) + ($p1['longitude'] - $point['longitude']) * ($p1['longitude'] - $point['longitude'])) > (($p2['latitude'] - $point['latitude']) * ($p2['latitude'] - $point['longitude']) + ($p2['longitude'] - $point['longitude']) * ($p2['longitude'] - $point['longitude']));
    }

    private static function drawPoly($points, $poly1 = array(), $poly2 = array())
    {
        $x = 0;
        $y = 0;

        $point_count = count($points);
        for ($i = 0; $i < $point_count; ++$i)
        {
            $x += $points[$i]['latitude'];
            $y += $points[$i]['longitude'];
        }

        $center['latitude'] = $x / $point_count;
        $center['longitude'] = $y / $point_count;

        for ($i = 0; $i < $point_count - 1; $i++)
        {
            $item = array();
            if ('in' == $points[$i]['type'])
            {
                continue;
            }

            for ($j = $i + 1 ; $j < $point_count - 1; $j++)
            {
                if ('in' == $points[$j]['type'])
                {
                    /*
                    if (true === self::pointCmp($points[$i], $points[$j], $center))
                    {
                        $tmp = $points[$i];
                        $points[$i] = $points[$j];
                        $points[$j] = $tmp;
                    }
                    */

                    $item[$j] = (true === self::pointCmp($points[$i], $points[$j], $center)) ? 1 : 0;
                }
            }

            if (!empty($item))
            {
                $ret = array_count_values($item);
                if (0 != $ret[1])
                {

                }
            }

            exit();
        }

        return $points;
    }

    private static function sortPoint($points, $poly1 = array(), $poly2 = array())
    {
        $x = 0;
        $y = 0;

        $point_count = count($points);
        for ($i = 0; $i < $point_count; ++$i)
        {
            $x += $points[$i]['latitude'];
            $y += $points[$i]['longitude'];
        }

        $center['latitude'] = $x / $point_count;
        $center['longitude'] = $y / $point_count;

        // var_dump(json_encode($points));
        for($i = 0; $i < $point_count - 1; $i++)
        {
            //for ($j = 0; $j < $point_count - $i - 1; $j++)
            for ($j = $i + 1 ; $j < $point_count - 1; $j++)
            {
                // if (true === self::pointCmp($points[$j], $points[$j + 1], $center))
                if (true === self::pointCmp($points[$i], $points[$j], $center))
                {
                    $tmp = $points[$i];
                    $points[$i] = $points[$j];
                    $points[$j] = $tmp;
                }
            }
        }

        return $points;
    }

    public static function polygonClip($polygon1, $polygon2)
    {
        if (empty($polygon1) || empty($polygon2))
        {
            return false;
        }

        $polygon1_count = count($polygon1);
        $polygon2_count = count($polygon2);
        if (($polygon1_count < 3) || ($polygon2_count < 3))
        {
            return false;
        }

        $points = array();
        $i = 0;

        $isCross = false;
        foreach ($polygon1 as $k => $v)
        {
            $j = 0;
            $poly1_idx = (++$i) % $polygon1_count;
            foreach ($polygon2 as $k => $v)
            {
                $poly2_idx = (++$j) % $polygon2_count;

                if (true !== self::isRectCross($polygon1[$i - 1], $polygon1[$poly1_idx], $polygon2[$j - 1], $polygon2[$poly2_idx]))
                {
                    continue;
                }

                if (true !== self::isLineCross($polygon1[$i - 1], $polygon1[$poly1_idx], $polygon2[$j - 1], $polygon2[$poly2_idx]))
                {
                    continue;
                }

                $cross = self::crossPoint($polygon1[$i - 1], $polygon1[$poly1_idx], $polygon2[$j - 1], $polygon2[$poly2_idx]);
                if (empty($cross))
                {
                    continue;
                }

                $cross['type'] = 'cross';
                $points[] = $cross;
                $isCross = true;
            }
        }

        foreach ($polygon1 as $k => $v)
        {
            if (self::isPointInPolygon($polygon2, $v))
            {
                $v['type'] = 'in';
                $points[] = $v;
            }
        }

        foreach ($polygon2 as $k => $v)
        {
            if (self::isPointInPolygon($polygon1, $v))
            {
                $v['type'] = 'in';
                $points[] = $v;
            }
        }

        if (count($points) < 3)
        {
            // 没有交集
            return array();
        }

        if ($isCross)
        {
            $points = self::sortPoint1($points);
        }

        foreach ($points as $k => $v)
        {
            unset($points[$k]['type']);
        }

        return $points;
    }
}

