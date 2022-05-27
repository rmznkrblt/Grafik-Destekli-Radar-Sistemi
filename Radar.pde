import processing.serial.*; // seri bağlantıyı oluşturan kütüphane
import java.awt.event.KeyEvent; // seri haberleşme portundan alacağımız datayı okumamızı sağlayan kütüphane
import java.io.IOException;

Serial myPort;
String angle="";
String distance="";
String data="";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1=0;
int index2=0;
PFont orcFont;
void setup() {
  
 size (1920, 1080);
 smooth();
 myPort = new Serial(this,"COM4", 9600); // serial haberleşmeyi başlatıyoruz.
 myPort.bufferUntil('.'); // noktaya kadar olan seri portları okuyoruz.
 orcFont = loadFont("PalatinoLinotype-BoldItalic-48.vlw");
}
void draw() {
  
  fill(98,245,31); //yeşil renk
  textFont(orcFont);
  // hareket bulanıklığı ve hareketli çizginin geçişlerini simüle eder.
  noStroke();
  fill(0,4); 
  rect(0, 0, width, 1010); 
  
  fill(98,245,31); // yeşil renk
  // radarı çizmek için fonksiyonları çağırıyoruz.
  drawRadar();  //radari ciziyor
  drawLine();   //cizgileri çiziyor
  drawObject();   //sensörün önüne geçen objeyi tespit ediyor
  drawText();
}
void serialEvent (Serial myPort) { // Serial Port'dan veri okumaya başlıyoruz.
  data = myPort.readStringUntil('.');
  data = data.substring(0,data.length()-1);
  
  index1 = data.indexOf(","); // ',' karakterini bulur ve "index1" değişkenine atar
  angle= data.substring(0, index1); // Sıfır konumundan index1 konumuna veya Arduino Board'un Seri Port'a gönderdiği açının değerine kadar olan verileri okuyoruz
  distance= data.substring(index1+1, data.length()); // verileri "indeks 1" konumundan verilerin sonuna kadar okuyoruz
  
  // string değerleri int değerlere dönüştürüyoruz.
  iAngle = int(angle);
  iDistance = int(distance);
}
void drawRadar() {
  pushMatrix();
  translate(960,1000); // başlangıç noktasını yeni noktaya taşır.
  noFill();
  strokeWeight(2);
  stroke(98,245,31);
  // yay çizgilerini çiziyoruz
  arc(0,0,1800,1800,PI,TWO_PI);
  arc(0,0,1400,1400,PI,TWO_PI);
  arc(0,0,1000,1000,PI,TWO_PI);
  arc(0,0,600,600,PI,TWO_PI);
  // açı çizgilerini çiziyoruz
  line(-960,0,960,0);
  line(0,0,-960*cos(radians(30)),-960*sin(radians(30)));
  line(0,0,-960*cos(radians(60)),-960*sin(radians(60)));
  line(0,0,-960*cos(radians(90)),-960*sin(radians(90)));
  line(0,0,-960*cos(radians(120)),-960*sin(radians(120)));
  line(0,0,-960*cos(radians(150)),-960*sin(radians(150)));
  line(-960*cos(radians(30)),0,960,0);
  popMatrix();
}
void drawObject() {
  pushMatrix();
  translate(960,1000); //başlangıç noktasını yeni kordinata koyduk
  strokeWeight(9);
  stroke(255,10,10); // kırmızı renk
  pixsDistance = iDistance*22.5; // cm den pixel'e çeviriyoruz
  if(iDistance<40){ // menzili 40 cm ile sınırladık
      // açıya ve mesafeye göre nesneyi çizdik
  line(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)),950*cos(radians(iAngle)),-950*sin(radians(iAngle)));
  }
  popMatrix();
}
void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30,250,60);
  translate(960,1000); // başlangıç noktasını yeni noktaya taşır.
  line(0,0,950*cos(radians(iAngle)),-950*sin(radians(iAngle))); // açıya göre doğruyu çizer
  popMatrix();
}
void drawText() { // ekrandaki metinleri çizer
  
  pushMatrix();
  if(iDistance>40) {
  noObject = "Out of Range";
  }
  else {
  noObject = "In Range";
  }
  fill(0,0,0);
  noStroke();
  rect(0, 1010, width, 1080);
  fill(98,245,31);
  textSize(25);
  text("10cm",1180,990);
  text("20cm",1380,990);
  text("30cm",1580,990);
  text("40cm",1780,990);
  textSize(40);
  text("Object: " + noObject, 240, 1050);
  text("Angle: " + iAngle +" °", 1050, 1050);
  text("Distance: ", 1300, 1050);
  if(iDistance<40) {
  text("        " + iDistance +" cm", 1400, 1050);
  }
  textSize(25);
  fill(98,245,60);
  translate(961+960*cos(radians(30)),982-960*sin(radians(30)));
  rotate(-radians(-60));
  text("30°",0,0);
  resetMatrix();
  translate(954+960*cos(radians(60)),984-960*sin(radians(60)));
  rotate(-radians(-30));
  text("60°",0,0);
  resetMatrix();
  translate(945+960*cos(radians(90)),990-960*sin(radians(90)));
  rotate(radians(0));
  text("90°",0,0);
  resetMatrix();
  translate(935+960*cos(radians(120)),1003-960*sin(radians(120)));
  rotate(radians(-30));
  text("120°",0,0);
  resetMatrix();
  translate(940+960*cos(radians(150)),1018-960*sin(radians(150)));
  rotate(radians(-60));
  text("150°",0,0);
  popMatrix(); 
}
