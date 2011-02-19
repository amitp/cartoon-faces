// Assorted functions for drawing cool shapes for games, plus demo
// showing the possibilities

// Copyright 2008 Amit J. Patel <amitp@cs.stanford.edu>
// License: MIT

package {
  import mx.core.UIComponent;
  import flash.display.*;
  import flash.geom.*;
  import mx.events.*;
  
  public class face extends UIComponent {
    private var mouth:Sprite = new Sprite();
    private var mouthMask:Shape = new Shape();
    private var currentWidth:Number = 0;
    private var currentHeight:Number = 0;

    private var mouthDebug:Sprite = new Sprite();
    
    [Bindable] public var m:Number = 0.4;
    [Bindable] public var p:Number = 0;
    [Bindable] public var q:Number = 0;
    [Bindable] public var r:Number = 0;
    [Bindable] public var s:Number = 0.5;
    
    function face() {
      addChild(mouth);
      mouth.mask = mouthMask;
      addChild(mouthMask);
      
      addChild(mouthDebug);
    }

    public function set(m:Number, p:Number, q:Number, r:Number, s:Number):void {
      this.m = m;
      this.p = p;
      this.q = q;
      this.r = r;
      this.s = s;
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
      mouth.x = 200;
      mouth.y = 100;
      mouthMask.x = mouth.x;
      mouthMask.y = mouth.y;
      mouthDebug.x = 200;
      mouthDebug.y = 300;
      currentWidth = unscaledWidth;
      currentHeight = unscaledHeight;
      redraw();
    }

    public function redraw():void {
      graphics.clear();
      mouth.graphics.clear();

      graphics.beginFill(0xdddddd);
      graphics.drawRect(0, 0, currentWidth, currentHeight);
      graphics.endFill();
      utils.drawGrid(graphics, currentWidth, currentHeight);

      drawBlob(graphics, new Point(200, 170), 125);
      
      drawEyeballs(graphics, new Point(200, 65), 30, 50, 6, 8);

      var mouthSize:Number = 15;
      
      mouthMask.graphics.clear();
      mouthMask.graphics.beginFill(0x000000);
      drawMouth3(mouthMask.graphics, mouthSize, false);
      mouthMask.graphics.endFill();

      mouth.graphics.clear();
      drawTeeth(mouth.graphics, new Point(0, mouthSize*(1 + 0.5*m)), mouthSize*m, 5, mouthSize*0.5, mouthSize*1, 1.0);
      mouth.graphics.lineStyle(1.5, 0x000000);
      drawMouth3(mouth.graphics, mouthSize, false);
      mouth.graphics.lineStyle();

      mouthDebug.graphics.clear();
      drawTeeth(mouthDebug.graphics, new Point(0, 40*(1 + 0.5*m)), 40*m, 5, 40*0.5, 40*1, 0.6);
      drawMouth3(mouthDebug.graphics, 40, true);
    }

    static public function drawBlob(g:Graphics, center:Point, radius:Number):void {
      g.lineStyle(1, 0x000000);
      g.beginFill(0xaa0000);
      for (var angle:Number = 0.0; angle < Math.PI * 2; angle += 0.01) {
        var p:Point = center.add(
            Point.polar(radius * (1 - 0.17 * Math.sin(5*angle)), angle));
        if (angle == 0.0) {
          g.moveTo(p.x, p.y);
        } else {
          g.lineTo(p.x, p.y);
        }
      }
      g.endFill();
      g.lineStyle();
    }
    
    static public function drawEyeballs(g:Graphics, center:Point,
                          width:Number, height:Number,
                          spacing:Number, size:Number):void {
      g.beginFill(0xffffff);
      g.lineStyle(1, 0x000000);
      g.drawEllipse(center.x - width - spacing/2, center.y - height/2,
                    width, height);
      
      g.drawEllipse(center.x + spacing/2, center.y - height/2,
                    width, height);
      g.lineStyle();
      g.endFill();

      g.beginFill(0x000000);
      g.drawCircle(center.x - width/2 - spacing/2, center.y, size);
      g.drawCircle(center.x + width/2 + spacing/2, center.y, size);
      g.endFill();
    }

    static public function drawTeeth(g:Graphics, center:Point,
                                     spacing:Number, smileWidth:int,
                                     toothWidth:Number, toothHeight:Number, alpha:Number):void {
      g.beginFill(0x000000, alpha);
      g.drawRect(center.x - toothWidth*smileWidth, center.y - toothHeight - spacing/2,
                 toothWidth*smileWidth*2, toothHeight*2 + spacing);
      g.endFill();
      
      g.beginFill(0xffffff, alpha);
      g.lineStyle(0, 0x000000, 0.5*alpha);
      for (var i:int = 0; i < smileWidth; i++) {
        g.drawRect(center.x + toothWidth*i, center.y - spacing/2 - toothHeight,
                  toothWidth, toothHeight);
        g.drawRect(center.x + toothWidth*i, center.y + spacing/2,
                  toothWidth, toothHeight);
        g.drawRect(center.x - toothWidth*(i+1), center.y - spacing/2 - toothHeight,
                  toothWidth, toothHeight);
        g.drawRect(center.x - toothWidth*(i+1), center.y + spacing/2,
                  toothWidth, toothHeight);
      }
      g.lineStyle();
      g.endFill();
    }

    public function drawMouth3(g:Graphics, scale:Number, debug:Boolean):void {
      var A:Point = new Point(2, (2+m)*s);
      var C:Point = new Point(A.x - r, A.y - r * A.y);
      var D:Point = new Point(0, 2 - 2*p - C.y);
      var B:Point = new Point(A.x,
                              D.y + (C.y-D.y) * (A.x-D.x) / (C.x-D.x));
      
      var G:Point = new Point(-2, A.y);
      var E:Point = new Point(G.x + r, G.y - r * G.y);
      var F:Point = new Point(G.x,
                              D.y + (E.y-D.y) * (G.x-D.x) / (E.x-D.x));
      
      var I:Point = new Point(G.x + r, G.y + r * (2+m - G.y));
      var J:Point = new Point(0, 2 + 2*m + 2*q - I.y);
      var H:Point = new Point(G.x,
                              J.y + (I.y-J.y) * (G.x-J.x) / (I.x-J.x));
      
      var K:Point = new Point(A.x - r, A.y + r * (2+m - A.y));
      var L:Point = new Point(A.x,
                              J.y + (K.y-J.y) * (A.x-J.x) / (K.x-J.x));

      var points:Array = [A, B, C, D, E, F, G, H, I, J, K, L, A];

      if (debug) {
        g.beginFill(0xff0000, 0.5);
        g.lineStyle(1, 0x000000, 0.5);
      }
      g.moveTo(scale*points[0].x, scale*points[0].y);
      for (var i:int = 1; i < points.length-1; i += 2) {
        g.curveTo(scale*points[i].x, scale*points[i].y,
                  scale*points[i+1].x, scale*points[i+1].y);
      }
      if (debug) {
        g.lineStyle();
        g.endFill();
      }

      if (debug) {
        g.lineStyle(0, 0x000000, 0.5);
        for (i = 0; i < points.length; i++) {
          if (i % 2 == 1) {
            g.beginFill(0x009966, 0.7);
            g.drawRect(scale*points[i].x - 2.5, scale*points[i].y - 2.5,
                       5, 5);
            g.endFill();
          } else {
            g.beginFill(0x9900cc, 0.7);
            g.drawCircle(scale*points[i].x, scale*points[i].y, (i==0)?6:4);
            g.endFill();
          }
        }
        g.lineStyle();
      }
    }
    
  }
}

