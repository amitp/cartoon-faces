// Copyright 2008 Amit J. Patel <amitp@cs.stanford.edu>
// License: MIT

package {
  import flash.display.*;
  import flash.geom.*;

  public class utils {
    public static var goldenRatio:Number = 1.61803399;
    private static var _nextColor:Number = Math.random();
    static public function nextColor():int {
      _nextColor += goldenRatio;
      // while (_nextColor > 1) _nextColor -= 1;
      return hsvToRgb(_nextColor * 360,
                      Math.sqrt(_nextColor*3 - Math.floor(_nextColor*3)),
                      Math.sqrt(_nextColor*5 - Math.floor(_nextColor*5)));
    }

    // Convert HSV into an RGB integer for Flash. Note that Hue must be in degrees.
    static public function hsvToRgb(h:Number, s:Number, v:Number): int {
      // See http://en.wikipedia.org/wiki/HSV_color_space
      var hi:int = int(h / 60) % 6;
      var f:Number = h/60 - Math.floor(h/60);
      var p:Number = v * (1-s);
      var q:Number = v * (1 - f*s);
      var t:Number = v * (1 - (1-f)*s);
      var r:Number, g:Number, b:Number;
      switch (hi) {
      case 0: r = v; g = t; b = p; break;
      case 1: r = q; g = v; b = p; break;
      case 2: r = p; g = v; b = t; break;
      case 3: r = p; g = q; b = v; break;
      case 4: r = t; g = p; b = v; break;
      case 5: r = v; g = p; b = q; break;
      }
      return int(Math.min(255, Math.floor(r*255))) * 65536 +
        int(Math.min(255, Math.floor(g*255))) * 256 +
        int(Math.min(255, Math.floor(b*255)));
    }

    // Draw a nice looking grid.
    static public function drawGrid(g:Graphics, width:Number, height:Number):void {
      for (var x:int = 0; x <= width; x += 10) {
        g.lineStyle(x % 100 == 0? 2 : 0, x % 50 == 0? 0x99bbdd : 0xaaccee);
        g.moveTo(0, x);
        g.lineTo(width, x);
        g.lineStyle();
      }
      for (var y:int = 0; y <= height; y += 10) {
        g.lineStyle(y % 100 == 0? 2 : 0, y % 50 == 0? 0x99bbdd : 0xaaccee);
        g.moveTo(y, 0);
        g.lineTo(y, height);
        g.lineStyle();
      }
    }

  // Intersection of two lines, represented as point+vector.
  static public function intersection(p:Point, u:Point, q:Point, v:Point):Point {
    var v_cross_u:Number = v.x*u.y - v.y*u.x;
    if (Math.abs(v_cross_u) <= 1e-4) {
      // Lines are parallel, or close to it, so use the midpoint
      return Point.interpolate(p, q, 0.5);
    }

    // Lines are not parallel, so compute the intersection, using the algorithm on
    // http://geometryalgorithms.com/Archive/algorithm_0104/algorithm_0104B.htm
    var w:Point = p.subtract(q);
    var v_cross_w:Number = v.x*w.y - v.y*w.x;
    var s:Number = -v_cross_w / v_cross_u;
    return new Point(p.x + u.x * s, p.y + u.y * s);
  }
    
  }
}
