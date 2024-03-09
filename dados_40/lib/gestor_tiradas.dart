import 'dart:math';

class GestorTiradas{
  Random random = Random();
  int calculateHits(int bs, int attacks){
    int hits = 0;
    int dice;
    for (var i = 0; i < attacks; i++) {
      dice = random.nextInt(6) + 1;
      if(dice >= bs){
        hits++;
      }
    }
    return hits;
  }

  int calculateWounds(int hits, int strength, int toughness){
    int wounds = 0;
    for (var i = 0; i < hits; i++) {
      if(strength*2 >= toughness){
        if(wounds2()){
          wounds++;
        }
      }else if(strength > toughness){
        if(wounds3()){
          wounds++;
        }
      }else if(strength == toughness){
        if(wounds4()){
          wounds++;
        }
      }else if(strength < toughness){
        if(wounds5()){
          wounds++;
        }
      }else if(strength <= toughness*2){
        if(wounds6()){
          wounds++;
        }
      }
    }
    return wounds;
  }

  List<int> calculateDamage(String damage, int wounds, int ap, int invul, int save){
    int totalDamage = 0;
    int dice;
    int actuallyWounds = 0;
    int finalSave = save + ap;

    for(int i = 0; i < wounds; i++){
      dice = random.nextInt(6)+1;
      if(dice <= finalSave){
        totalDamage = applyDamage(damage, totalDamage);
        actuallyWounds++;
      }
    }
    if(invul != 0 && invul != 1) {
      totalDamage = 0;
      for(int i = 0; i < actuallyWounds; i++){
        dice = random.nextInt(6)+1;
        if(dice <= invul){
          totalDamage = applyDamage(damage, totalDamage);
        }
      }
    }

    return [actuallyWounds, totalDamage];
  }

  int applyDamage(String damage, int totalDamage){
    switch(damage){
      case "1":
        totalDamage++;
        break;
      case "2":
        totalDamage+=2;
        break;
      case "3":
        totalDamage+=3;
        break;
      case "d6":
        totalDamage+=random.nextInt(6)+1;
        break;
      case "d3":
        totalDamage+=random.nextInt(3)+1;
        break;
    }
    return totalDamage;
  }

  bool wounds2(){
    int dice = random.nextInt(6) + 1;
    bool hasWounded = false;
    if(dice >= 2){
      hasWounded = true;
    }
    return hasWounded;
  }
  bool wounds3(){
    int dice = random.nextInt(6) + 1;
    bool hasWounded = false;
    if(dice >= 3){
      hasWounded = true;
    }
    return hasWounded;
  }
  bool wounds4(){
    int dice = random.nextInt(6) + 1;
    bool hasWounded = false;
    if(dice >= 4){
      hasWounded = true;
    }
    return hasWounded;
  }
  bool wounds5(){
    int dice = random.nextInt(6) + 1;
    bool hasWounded = false;
    if(dice >= 5){
      hasWounded = true;
    }
    return hasWounded;
  }
  bool wounds6(){
    int dice = random.nextInt(6) + 1;
    bool hasWounded = false;
    if(dice >= 6){
      hasWounded = true;
    }
    return hasWounded;
  }
}