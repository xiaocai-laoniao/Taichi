public class MyFluidDataConfig {
  float x;  // 圆心位置x
  float y; // 圆心位置y
  float radius = 100; // 半径
  boolean isClockwise; // 是否是顺时针
  float angleSpeed = 0.04;
  float rx, ry, prx, pry; // 圆周运动，弧上的点位置，以及上一帧的点位置
  float angle = 0; // 角度
  color c; // 颜色
}


public class MyFluidData implements DwFluid2D.FluidData {
  MyFluidDataConfig config1;
  MyFluidDataConfig config2;
  Amplitude rms;

  MyFluidData(Amplitude rms) {
    this.rms = rms;
    
    float x1 = width * 0.5;
    float y1 = height * 0.5;
    
    config1 = new MyFluidDataConfig();
    config1.x = x1;
    config1.y = y1;
    config1.radius = 130;
    config1.isClockwise = true;
    config1.angleSpeed = 0.05;
    config1.c = color(0.0, 0.0, 0.0);
    config1.angle = PI / 2;

    config2 = new MyFluidDataConfig();
    config2.x = x1;
    config2.y = y1;
    config2.radius = 130;
    config2.isClockwise = true;
    config2.angleSpeed = 0.04;
    config2.c = color(0.0, 0.0, 0.0);
    config2.angle = - PI / 2;
  }

  void my_update(DwFluid2D fluid, MyFluidDataConfig config) {
    float vscale = 14;
    
    float soundLevel = rms.analyze() * 1000;

    float delta = random(-3, 3);
    // 极坐标下计算弧上点的位置，用一个随机量进行抖动
    config.rx = config.x + (config.radius + delta) * cos(config.angle); 
    config.ry = config.y + (config.radius + delta) * sin(config.angle);

    // 计算速度
    float vx = (config.rx - config.prx) * vscale;
    float vy = (config.ry - config.pry) * vscale;
    // 顺时针的话，需要乘以-1，因为y轴相反
    if (config.isClockwise) {
      vy = (config.ry - config.pry) * (-vscale);
    }

    float px = config.rx;
    float py = config.ry;
    // 顺时针的话，需要乘以-1，因为y轴相反
    if (config.isClockwise) {
      py = height - config.ry;
    }

    // 给流体上的点添加速度
    fluid.addVelocity(px, py, 16, vx, vy);
    
    float radius1 = map(soundLevel, 10, 600, 15, 20);
    float radius2 = map(soundLevel, 10, 500, 8, 12);
    println(soundLevel, radius1, radius2);
    
    // 给流体上的点添加密度，颜色为c，半径为radius1，稍微大点
    fluid.addDensity(px, py, radius1, red(config.c) / 255.0, green(config.c) / 255.0, blue(config.c) / 255.0, 1.0f);
    // 给流体上的点添加密度，颜色为白色，半径为radius2，稍微小点
    fluid.addDensity(px, py, radius2, 1.0f, 1.0f, 1.0f, 1.0f);
    //fluid.addTemperature(px, py, 30, 10);

    // 现在终将成为过去
    config.prx = config.rx;
    config.pry = config.ry;

    // 增加弧度角，用于下一帧计算，才能旋转
    float angleSpeed = constrain(radians(soundLevel * 0.03), 0.01, 0.08) * 3;
    println(soundLevel, angleSpeed);
    config.angle += angleSpeed;
  }

  @Override
    public void update(DwFluid2D fluid) {
    my_update(fluid, config1);
    my_update(fluid, config2);
  }
}
