#include <Servo.h>

#define BUFFER_MAX 24
#define CENTER_MIN 490
#define CENTER_MAX 510
#define MAX_MAX 590
#define MON_MIN 410

Servo servoA;

byte counter = 0;
char buffer[BUFFER_MAX];

void setup() {
  pinMode(13, OUTPUT);
  Serial.begin(19200);  
  servoA.attach(10);
}

void loop() {
  if (Serial.available()) {
    char c = (char) Serial.read();
    if(c == '<')
    {
      digitalWrite(13,HIGH);
      counter = 0;
      memset( buffer, 0, BUFFER_MAX);
    }
    else if(c == '>')
    {
      digitalWrite(13,LOW);
      processMessage();
    }
    else
    {
      if(counter == BUFFER_MAX)
        counter = 0;
        
      buffer[counter++] = c;      
    }    
      
    delay(10);
  }
}

void processMessage()
{
//  Serial.println(buffer);
//  Serial.println(counter, DEC);
  
  int count = 0;
  int tokenCount = 0;
  char tokenValue[4];
  int tokenValues[4];
  for(int i=0; i<=counter; i++)
  {
    if(buffer[i] == ':' || i == counter)
    {
      tokenValues[tokenCount++] = atoi(tokenValue);
      
      count = 0;
      memset(tokenValue, 0, 4);
    }
    else
    {
      tokenValue[count++] = buffer[i];
    }
  }
  
//  Serial.println(tokenValues[0]);
//  Serial.println(tokenValues[1]);
//  Serial.println(tokenValues[2]);
//  Serial.println(tokenValues[3]);
  
  // If the devide is holded horizontally
  if( tokenValues[3] > MAX_MAX )
  {
    int servoValue = ((int)tokenValues[0]) - 180;
    if(servoValue < 0)
      servoValue *= -1;
    servoA.write(servoValue);
  }
  else
  {
    int angle = 90;
    if(tokenValues[2] < CENTER_MIN)
      angle = 180 - (tokenValues[2] - 400);
    if(tokenValues[2] > CENTER_MAX)
      angle = 600 - tokenValues[2];
      
    if(angle > 180)
      angle = 180;
    if(angle < 0)
      angle = 0;
      
    servoA.write(angle);
  }
  
}
