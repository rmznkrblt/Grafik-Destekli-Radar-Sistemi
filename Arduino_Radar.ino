#include <Servo.h>. 

//sensörde kullanmak üzere trig ve echo pinini tanımlıyoruz
const int trigPin = 4;
const int echoPin = 3;

long duration;
int distance;
Servo myServo;


void setup() {

//giriş ve çıkış belirliyoruz.
//serial haberleşmeyi başlatıyoruz
  
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT); 
  Serial.begin(9600);
  myServo.attach(9); 
  
}

void loop() {
  //15 ile 165 derece arasında 1 derece aralıklarla servo motoru ile soldan sağa döndürüyoruz.
  for(int i=15;i<=165;i++){  
  myServo.write(i);
  delay(30);
  distance = calculateDistance();
  
  Serial.print(i); 
  Serial.print(","); 
  Serial.print(distance);
  Serial.print(".");
  }

  
 //15 ile 165 derece arasında 1 derece aralıklarla servo motoru sağdan sola döndürüyoruz.
  for(int i=165;i>15;i--){  
  myServo.write(i);
  delay(30);
  distance = calculateDistance();
  Serial.print(i);
  Serial.print(",");
  Serial.print(distance);
  Serial.print(".");
  }
}

//calculateDistance  ultrasonik sensörlerdeki mesafe bilgisini alan işlemdir.
int calculateDistance(){ 
  
  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2);
 
  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH); 
  distance= duration*0.034/2;
  return distance;

}
