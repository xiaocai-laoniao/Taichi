import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.fluid.DwFluid2D;

import processing.core.*;
import processing.opengl.PGraphics2D;
import processing.sound.*;

// 欢迎关注 小菜与老鸟 （公众号、视频号、Bilibili号）

int viewport_w = 600; // 定义窗口宽
int viewport_h = 600; // 定义窗口高
color bg_color = #FFFFFF; // 背景色
color line_color = #000000; // 线条颜色

DwFluid2D fluid; // 流体
PGraphics2D pg_fluid; // 流体层

// 声音麦克风输入
AudioIn audioIn;
// 振幅-音量
Amplitude rms;

Taichi taichi; // 太极
PGraphics2D pg_taichi;  // 太极图层
PGraphics2D pg_obstacles; // 障碍物
float taichi_radius = 100;

void settings() {
  size(viewport_w, viewport_h, P2D);
}

void setup() {
  background(bg_color);
  frameRate(60);

  // 设定声音
  setupSound();
  // 设置流体参数
  setupFluid();

  // 设置太极图
  setupTaichi();
}

void setupSound() {
  audioIn = new AudioIn(this, 0);
  audioIn.play();

  rms = new Amplitude(this);
  rms.input(audioIn);
}

void setupFluid() {
  // 初始化pixelflow
  DwPixelFlow context = new DwPixelFlow(this);
  context.print();
  context.printGL();

  // 流体模拟
  fluid = new DwFluid2D(context, width, height, 1);
  fluid.param.dissipation_velocity = 0.70f;
  fluid.param.dissipation_density  = 0.60f;

  fluid.addCallback_FluiData(new MyFluidData(rms));

  // 流体层
  pg_fluid = (PGraphics2D)createGraphics(width, height, P2D);

  // 障碍物层
  pg_obstacles = (PGraphics2D)createGraphics(viewport_w, viewport_h, P2D);
  pg_obstacles.smooth(4);
}

void setupTaichi() {
  pg_taichi = (PGraphics2D)createGraphics(viewport_w, viewport_h, P2D);
  pg_taichi.smooth(4);

  taichi = new Taichi(new PVector(width / 2, height / 2), 100, pg_taichi, rms);
}

void draw() {
  // 流体更新
  drawFluid();
  // 太极图
  drawTaichi();
}

void drawFluid() {
  // 绘制障碍物
  drawObstacles();

  // 给流体增加障碍物
  fluid.addObstacles(pg_obstacles);
  // 流体更新
  fluid.update();
  fluid.renderFluidTextures(pg_fluid, 0);

  // 显示流体层
  image(pg_fluid, 0, 0);
  // 显示障碍物层
  image(pg_obstacles, 0, 0);
}

void drawObstacles() {
  pg_obstacles.beginDraw();
  pg_obstacles.blendMode(REPLACE);
  pg_obstacles.clear();

  float x = width * 0.5;
  float y = height * 0.5;
  pg_obstacles.pushMatrix();
  pg_obstacles.translate(x, y);
  pg_obstacles.stroke(line_color);
  pg_obstacles.strokeWeight(2);
  pg_obstacles.noFill();
  pg_obstacles.circle(0, 0, 500);
  pg_obstacles.popMatrix();

  pg_obstacles.endDraw();
}

void drawTaichi() {
  pg_taichi.beginDraw();
  pg_taichi.blendMode(REPLACE);
  pg_taichi.clear();

  pg_taichi.pushMatrix();
  taichi.display();
  pg_taichi.popMatrix();

  pg_taichi.endDraw();

  image(pg_taichi, 0, 0);
}
