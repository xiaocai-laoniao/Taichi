// 欢迎关注 小菜与老鸟 （公众号、视频号、Bilibili号）

class Taichi {
  PVector location;
  float radius;
  PGraphics2D pg;
  float angle = 0;
  Amplitude rms;  

  Taichi(PVector location, float radius, PGraphics2D pg, Amplitude rms) {
    this.location = location;
    this.radius = radius;
    this.pg = pg;
    this.rms = rms;
  }

  void display() {
    float d = 2 * radius;
    float soundLevel = rms.analyze();
    angle += TWO_PI/360 * soundLevel * 20;
    
    pg.noStroke();
    pg.translate(location.x, location.y);  // 平移坐标系，方便使用相对位置进行绘制
    pg.rotate(angle);
    pg.fill(0);
    pg.arc(0, 0, d, d, PI / 2, PI * 3 / 2);

    pg.fill(255);
    pg.arc(0, 0, d, d, -PI / 2, PI / 2);

    pg.fill(255);
    pg.circle(0, d / 4, radius);

    pg.fill(0);
    pg.circle(0, -d / 4, radius);

    pg.fill(0);
    pg.circle(0, d / 4, radius / 5);

    pg.fill(255);
    pg.circle(0, -d / 4, radius / 5);
  }
}
