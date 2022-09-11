class Needs {
   double couscous=0;
   double smid =0;
   double farine=0;
   double kam7=0;
   double ades=0;
   double loubya=0;
   double hmissa=0;
   double riz=0;
  double jalbana=0;
  double m7amsa=0;
  double tamr=0;
   double zbib=0;

  Needs(
     this.couscous,
     this.smid,
     this.ades,
     this.farine,
     this.hmissa,
     this.jalbana,
     this.kam7,
     this.loubya,
     this.m7amsa,
     this.riz,
     this.tamr,
     this.zbib,
  );
  
  Needs.fromJson(Map<String,dynamic> json){
    couscous=json['couscous']??0;
    smid=json['smid']??0;
    ades=json['3des']??0;
    farine=json['farine']??0;
    hmissa=json['7missa']??0;
    jalbana=json['jalbana']??0;
    kam7=json['kam7']??0;
    loubya=json['loubya']??0;
    m7amsa=json['m7amsa']??0;
    riz=json['riz']??0;
    tamr=json['tamr']??0;
    zbib=json['zbib']??0;
  }
  
}
