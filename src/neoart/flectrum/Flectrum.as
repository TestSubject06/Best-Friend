/* Flectrum version 1.0
   2009/08/15
   Christian Corti
   Neoart Costa Rica

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 	 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 	 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
 	 IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package neoart.flectrum {
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.utils.*;

  public class Flectrum extends Sprite {
    public static const UP:   String = "up";
    public static const LEFT: String = "left";
    public static const DOWN: String = "down";
    public static const RIGHT:String = "right";

    public static const METER:String = "meter";
    public static const DECAY:String = "decay";
    public static const PEAKS:String = "peaks";

    public var backgroundBeat:Boolean;

    protected var timer:Timer;
    protected var meter:BitmapData;
    protected var background:Bitmap;
    protected var foreground:Bitmap;
    protected var buffer:BitmapData;
    protected var input:BitmapData;
    protected var output:BitmapData;

    protected var levels:Vector.<Number>;
    protected var spectrum:Vector.<Number>;
    protected var destPoint:Point;
    protected var sourceRect:Rectangle;
    protected var sectionWidth:int;
    protected var sectionHeight:int;
    protected var realHeight:int;

    protected var m_soundEx:SoundEx;
    protected var m_direction:String = UP;
    protected var m_mode:String = PEAKS;
    protected var m_columns:int;
    protected var m_columnSize:int = 10;
    protected var m_columnSpacing:int = 2;
    protected var m_rows:int;
    protected var m_rowSize:int = 3;
    protected var m_rowSpacing:int = 1;
    protected var m_showBackground:Boolean = true;
    protected var m_backgroundAlpha:Number = 0.2;
    protected var m_decay:Number = 0.02;
    protected var m_decayAlpha:uint = 0xd0000000;
    protected var m_peaksAlpha:uint = 0xff000000;

    protected var m_colors:Array = [0xff3939, 0xffb320, 0xfff820, 0x50d020];
    protected var m_alphas:Array = [1, 1, 1, 1];
    protected var m_ratios:Array = [20, 105, 145, 250];

    public function Flectrum(soundEx:SoundEx, columns:int = 15, rows:int = 32) {
      this.soundEx = soundEx;
      m_columns = columns;
      m_rows = rows;
      mouseEnabled = false;
      tabEnabled = false;

      background = new Bitmap(null, "always", true);
      foreground = new Bitmap(null, "always", true);
      levels     = new Vector.<Number>;
      spectrum   = new Vector.<Number>;
      destPoint  = new Point();
      sourceRect = new Rectangle();

      timer = new Timer(20);
      timer.addEventListener(TimerEvent.TIMER, peaksHandler);
      reset();
    }

    public function useBitmap(image:BitmapData):void {
      meter = image.clone();
      clone();
    }

    public function useDraw():void {
      meter.dispose();
      meter = null;
      draw();
    }

    protected function reset():void {
      timer.reset();
      levels.length = m_columns;
      for (var i:int = 0; i < m_columns; ++i) levels[i] = 0;
      while (numChildren) removeChildAt(0);

      background.alpha = m_backgroundAlpha;
      background.rotation = 0;
      background.x = 0;
      background.y = 0;
      foreground.rotation = 0;
      foreground.x = 0;
      foreground.y = 0;
      if (meter) clone(); else draw();
    }

    protected function start():void {
      if (!soundEx) return;
      timer.reset();
      timer.start();
    }

    protected function clone():void {
      sectionWidth  = meter.width + m_columnSpacing;
      sectionHeight = m_rowSize + m_rowSpacing;
      realHeight    = meter.height + m_rowSpacing;

      var h:int = meter.height, i:int, w:int = m_columns * sectionWidth - m_columnSpacing;

      output = new BitmapData(w, h, true, 0);
      buffer = output.clone();
      output.lock();
      destPoint.x = 0;

      for (i = 0; i < m_columns; ++i) {
        output.copyPixels(meter, meter.rect, destPoint);
        destPoint.x += sectionWidth;
      }
      m_rows = realHeight / sectionHeight;

      if (m_rowSpacing > 0) {
        sourceRect.width = w;
        sourceRect.height = m_rowSpacing;
        sourceRect.y = h - sectionHeight;

        for (i = 0; i < m_rows; ++i) {
          output.fillRect(sourceRect, 0);
          sourceRect.y -= sectionHeight;
        }
      }
      output.unlock();
      destPoint.x = 0;
      sourceRect.width = m_columnSize = meter.width;

      input = buffer.clone();
      input.threshold(output, output.rect, destPoint, "==", 0xff000000, 0x00ffffff, 0xffffffff, true);
      output.fillRect(output.rect, 0);

      background.bitmapData = input;
      if (m_showBackground) addChild(background);
      foreground.bitmapData = output;
      addChild(foreground);
      if (m_direction != UP) direction = m_direction;
    }

    protected function draw():void {
      visible = false;
      sectionWidth  = m_columnSize + m_columnSpacing;
      sectionHeight = m_rowSize + m_rowSpacing;
      realHeight    = m_rows * sectionHeight;

      var h:int = realHeight - m_rowSpacing, i:int, matrix:Matrix,
          p:int = m_rowSize, w:int = m_columns * sectionWidth - m_columnSpacing;

      if (m_colors.length < 2) {
        graphics.beginFill(m_colors[0], m_alphas[0]);
      } else {
        matrix = new Matrix();
        matrix.createGradientBox(w, h, Math.PI * 0.5, 0, 0);
        graphics.beginGradientFill(GradientType.LINEAR, m_colors, m_alphas, m_ratios, matrix, SpreadMethod.PAD, InterpolationMethod.LINEAR_RGB);
      }
      graphics.drawRect(0, 0, w, h);
      graphics.endFill();

      for (i = 0; i < m_rows; ++i) {
        graphics.beginFill(0, 1);
        graphics.drawRect(0, p, w, m_rowSpacing);
        graphics.endFill();
        p += sectionHeight;
      }
      p = m_columnSize;

      for (i = 1; i < m_columns; ++i) {
        graphics.beginFill(0, 1);
        graphics.drawRect(p, 0, m_columnSpacing, h);
        graphics.endFill();
        p += sectionWidth;
      }
      output = new BitmapData(w, h, true, 0);
      buffer = output.clone();
      output.draw(this);
      graphics.clear();

      input = buffer.clone();
      input.threshold(output, output.rect, destPoint, "==", 0xff000000, 0x00ffffff, 0xffffffff, true);
      output.fillRect(output.rect, 0);

      background.bitmapData = input;
      if (m_showBackground) addChild(background);
      foreground.bitmapData = output;
      addChild(foreground);

      sourceRect.width = m_columnSize;
      if (m_direction != UP) direction = m_direction;
      visible = true;
    }

    protected function startHandler(e:Event):void {
      m_soundEx.removeEventListener(SoundEx.SOUND_START, startHandler);
      m_soundEx.addEventListener(SoundEx.SOUND_STOP, stopHandler);
      m_soundEx.addEventListener(Event.SOUND_COMPLETE, stopHandler);
      timer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
      timer.repeatCount = 0;
      start();
    }

    protected function stopHandler(e:Event):void {
      var i:int, t:Number = 0.0;
      for (i = 0; i < m_columns; ++i)
        if (levels[i] > t) t = levels[i];

      m_soundEx.removeEventListener(Event.SOUND_COMPLETE, stopHandler);
      m_soundEx.removeEventListener(SoundEx.SOUND_STOP, stopHandler);
      m_soundEx.addEventListener(SoundEx.SOUND_START, startHandler);

      timer.reset();
      timer.repeatCount = int(t / m_decay) + 1;
      timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
      timer.start();
    }

    protected function completeHandler(e:Event):void {
      if (backgroundBeat) background.alpha = m_backgroundAlpha;
      timer.reset();
      timer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
    }

    protected function meterHandler(e:TimerEvent):void {
      var h:int, i:int;
      spectrum = m_soundEx.getStereoAdd(m_columns);
      buffer.fillRect(buffer.rect, 0);
      sourceRect.x = 0;

      for (i = 0; i < m_columns; ++i) {
        h = int(spectrum[i] * m_rows) * sectionHeight;
        sourceRect.height = h;
        sourceRect.y = realHeight - h;
        buffer.fillRect(sourceRect, 0xff000000);
        sourceRect.x += sectionWidth;
      }
      output.copyPixels(input, input.rect, destPoint, buffer);
      if (backgroundBeat) background.alpha = m_soundEx.peak;
      e.updateAfterEvent();
    }

    protected function decayHandler(e:TimerEvent):void {
      var a:Number, h:int, i:int;
      spectrum = m_soundEx.getStereoSampling(m_columns);
      output.lock();
      sourceRect.x = 0;
      buffer.fillRect(buffer.rect, m_decayAlpha);
      output.copyPixels(output, output.rect, destPoint, buffer);
      buffer.fillRect(buffer.rect, 0);

      for (i = 0; i < m_columns; ++i) {
        a = spectrum[i];
        if (a > levels[i]) levels[i] = a;
        h = int(levels[i] * m_rows) * sectionHeight;
        sourceRect.height = h;
        sourceRect.y = realHeight - h;
        buffer.fillRect(sourceRect, m_peaksAlpha);
        sourceRect.x += sectionWidth;
        levels[i] -= m_decay;
      }
      output.copyPixels(input, input.rect, destPoint, buffer, null, true);
      output.unlock();
      if (backgroundBeat) background.alpha = m_soundEx.peak;
      e.updateAfterEvent();
    }

    protected function peaksHandler(e:TimerEvent):void {
      var a:Number, h:int, i:int;
      spectrum = m_soundEx.getStereoAdd(m_columns);
      buffer.fillRect(buffer.rect, 0);
      sourceRect.x = 0;

      for (i = 0; i < m_columns; ++i) {
        a = spectrum[i];
        h = int(a * m_rows) * sectionHeight;
        sourceRect.height = h;
        sourceRect.y = realHeight - h;
        buffer.fillRect(sourceRect, 0xff000000);

        if (a > levels[i]) {
          levels[i] = a;
        } else {
          h = int(levels[i] * m_rows) * sectionHeight;
          sourceRect.y = realHeight - h;
        }

        sourceRect.height = m_rowSize;
        buffer.fillRect(sourceRect, m_peaksAlpha);
        sourceRect.x += sectionWidth;
        levels[i] -= m_decay;
      }
      output.copyPixels(input, input.rect, destPoint, buffer);
      if (backgroundBeat) background.alpha = m_soundEx.peak;
      e.updateAfterEvent();
    }

    public function get soundEx():SoundEx { return m_soundEx; }
    public function set soundEx(value:SoundEx):void {
      if (m_soundEx) m_soundEx.removeEventListener(SoundEx.SOUND_START, startHandler);
      m_soundEx = value;
      value.addEventListener(SoundEx.SOUND_START, startHandler);
    }

    public function get direction():String { return m_direction; }
    public function set direction(value:String):void {
      if (value == m_direction || !Flectrum[value.toUpperCase()]) return;

      switch (value) {
        case UP:
          foreground.rotation = 0;
          foreground.x = 0;
          foreground.y = 0;
          break;
        case LEFT:
          foreground.rotation = 270;
          foreground.x = 0;
          foreground.y = foreground.height;
          break;
        case DOWN:
          foreground.rotation = 180;
          foreground.x = foreground.width;
          foreground.y = foreground.height;
          break;
        case RIGHT:
          foreground.rotation = 90;
          foreground.x = foreground.width;
          foreground.y = 0;
          break;
      }
      background.rotation = foreground.rotation;
      background.x = foreground.x;
      background.y = foreground.y;
      m_direction = value;
    }

    public function get mode():String { return m_mode; }
    public function set mode(value:String):void {
      if (value == m_mode || !Flectrum[value.toUpperCase()]) return;
      timer.removeEventListener(TimerEvent.TIMER, this[m_mode +"Handler"]);
      timer.addEventListener(TimerEvent.TIMER, this[value +"Handler"]);
      m_mode = value;
    }

    public function get delay():int { return timer.delay; }
    public function set delay(value:int):void {
      timer.delay = value;
    }

    public function get columns():int { return m_columns; }
    public function set columns(value:int):void {
      if (value == m_columns) return;
      if (value < 2) value = 2;
        else if (value > 256) value = 256;
      m_columns = value;
      reset();
    }

    public function get columnSize():int { return m_columnSize; }
    public function set columnSize(value:int):void {
      if (value == m_columnSize) return;
      if (value < 1) value = 1;
      m_columnSize = value;
      reset();
    }

    public function get columnSpacing():int { return m_columnSpacing; }
    public function set columnSpacing(value:int):void {
      if (value == m_columnSpacing) return;
      m_columnSpacing = value;
      reset();
    }

    public function get rows():int { return m_rows; }
    public function set rows(value:int):void {
      if (value == m_rows) return;
      if (value < 3) value = 3;
      m_rows = value;
      reset();
    }

    public function get rowSize():int { return m_rowSize; }
    public function set rowSize(value:int):void {
      if (value == m_rowSize) return;
      if (value < 1) value = 1;
      m_rowSize = value;
      reset();
    }

    public function get rowSpacing():int { return m_rowSpacing; }
    public function set rowSpacing(value:int):void {
      if (value == m_rowSpacing) return;
      m_rowSpacing = value;
      reset();
    }

    public function get showBackground():Boolean { return m_showBackground; }
    public function set showBackground(value:Boolean):void {
      if (value == m_showBackground) return;
      m_showBackground = value;
      reset();
    }

    public function get backgroundAlpha():Number { return m_backgroundAlpha; }
    public function set backgroundAlpha(value:Number):void {
      background.alpha = m_backgroundAlpha = value;
    }

    public function get decay():Number { return m_decay; }
    public function set decay(value:Number):void {
      if (value < 0) value = 0;
        else if (value > 1) value = 1;
      m_decay = value;
    }

    public function get decayAlpha():Number { return m_decayAlpha / 255; }
    public function set decayAlpha(value:Number):void {
      if (value < 0) value = 0;
        else if (value > 1) value = 1;
      m_decayAlpha = int(value * 255) << 24;
    }

    public function get peaksAlpha():Number { return m_peaksAlpha / 255; }
    public function set peaksAlpha(value:Number):void {
      if (value < 0) value = 0;
        else if (value > 1) value = 1;
      m_peaksAlpha = int(value * 255) << 24;
    }
  }
}