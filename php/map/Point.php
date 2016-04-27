<?php
namespace Libs;

class Point
{
    public static function se($p1, $p2, $p3)
    {
        return self::pe($p1['longitude'], $p1['latitude'], $p2['longitude'],
            $p2['latitude'], $p3['longitude'], $p3['latitude']);
    }

    private static function pe($a, $b, $c, $d, $e, $f)
    {
        if ((($c - $a) * ($f - $b)) === (($e - $a) * ($d - $b)))
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public static function li($point, $p1, $p2)
    {
        return self::it($point['longitude'], $point['latitude'], 
            $point['longitude'] + $p1['latitude'] - $p2['latitude'],
            $point['latitude'] + $p2['longitude'] - $p1['longitude'], 
            $p1['longitude'], $p1['latitude'], $p2['longitude'], $p2['latitude']);
    }

    private static function it($a, $b, $c, $d, $e, $f, $g, $h)
    {
        $t = (($a - $e) * ($f - $h) - ($b - $f) * ($e - $g)) / (($a - $c) * ($f - $h) - ($b - $d) * ($e - $g));
        return ['longitude' => (($a + ($c - $a) * $t)),
                'latitude' => (($b + ($d - $b) * $t))];
    }

    private static function lw($a, $b, $c)
    {
        $a = max($a, $b);
        $a = min($a, $c);
        return $a;
    }

    private static function ew($a, $b, $c)
    {
        while ($a > $c)
        {
            $a -= $c - $b;
        }

        while ($a < $b)
        {
            $a += $c - $b;
        }

        return $a;
    }

    private static function oi($a)
    {
        return pi() * $a / 180;
    }

    private static function td($a, $b, $c, $d)
    {
        return 6370996.81 * acos(sin($c) * sin($d) + cos($c) * cos($d) * cos($b - $a));
    }

    private static function wv($a, $b)
    {
        $a['longitude'] = self::ew($a['longitude'], -180, 180);
        $a['latitude'] = self::lw($a['latitude'], -74, 74);
        $b['longitude'] = self::ew($b['longitude'], -180, 180);
        $b['latitude'] = self::lw($b['latitude'], -74, 74);

        return self::td(self::oi($a['longitude']), self::oi($b['longitude']), 
                        self::oi($a['latitude']), self::oi($b['latitude']));
    }

    public static function di($p1, $p2)
    {
        return self::wv($p1, $p2);
    }

    public static function valid($p)
    {
        //var point_reg = /^\d{1,3}.\d{0,6}$/;
        //return point_reg.test(p);
    }
}

