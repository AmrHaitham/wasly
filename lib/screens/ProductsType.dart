// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:e_commerce/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class ProductsType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          CustomCard(title: "سوبر ماركت",image: "assets/types/سوبر ماركت.jpeg",),
          CustomCard(title: "خضروات و فواكه",image: "assets/types/خضروات وفواكه.jpeg",),
          CustomCard(title: "مخبوزات وحلويات",image: "assets/types/مخبوزات وحلويات.jpeg",),
          CustomCard(title: "لحوم ودواجن",image: "assets/types/لحوم ودواجن.jpeg",),
          CustomCard(title: "محمصات",image: "assets/types/محمصات.jpeg",),
          CustomCard(title: "شحن ودفع فواتير",image: "assets/types/شحن ودفع الفواتير.jpeg",),
          CustomCard(title: "بقوليات",image: "assets/types/بقوليات.jpeg",),
          CustomCard(title: "مستحضرات تجميل",image: "assets/types/مستحضرات تجميل.jpeg"),
          CustomCard(title: "مطاعم وكافيهات",image:"assets/types/مطاعم وكافيهات.jpeg" ,),
          CustomCard(title: "منظفات",image: "assets/types/منظفات.jpeg",),
          CustomCard(title: "عطارة وأعشاب",image: "assets/types/عطارة وأعشاب.jpeg"),
          CustomCard(title: "خدمات منزلية",image: "assets/types/خدمات منزلية.jpeg"),
        ],
      ),
    );
  }
}
