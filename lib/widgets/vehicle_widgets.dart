import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TaxiWidget extends StatelessWidget {
  final double scale;
  const TaxiWidget({super.key, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: SizedBox(
        width: 120, height: 70,
        child: Stack(children: [
          Positioned(left: 10, top: 25, right: 10, bottom: 15,
            child: Container(decoration: BoxDecoration(color: const Color(0xFFFFB300), borderRadius: BorderRadius.circular(12)))),
          Positioned(left: 35, top: 10, right: 30, bottom: 40,
            child: Container(decoration: BoxDecoration(color: const Color(0xFFFFB300), borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))))),
          Positioned(left: 42, top: 15, right: 37, bottom: 42,
            child: Container(decoration: BoxDecoration(color: const Color(0xFF1A1B26), borderRadius: BorderRadius.circular(8)))),
          Positioned(left: 50, top: 2, right: 45, bottom: 60,
            child: Container(decoration: BoxDecoration(color: const Color(0xFFFFB300), borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.black, width: 1)),
              child: const Center(child: Text('TAXI', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold, color: Colors.black))))),
          Positioned(left: 20, bottom: 5, child: _wheel()),
          Positioned(right: 20, bottom: 5, child: _wheel()),
        ]),
      ),
    );
  }
  Widget _wheel() => Container(width: 18, height: 18,
    decoration: BoxDecoration(color: const Color(0xFF1A1B26), shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade600, width: 2)));
}

class BusWidget extends StatelessWidget {
  final double scale;
  const BusWidget({super.key, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(scale: scale,
      child: SizedBox(width: 140, height: 75,
        child: Stack(children: [
          Positioned(left: 5, top: 15, right: 5, bottom: 15,
            child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade400, width: 1.5)))),
          Positioned(left: 15, top: 22, right: 15, bottom: 45,
            child: Row(children: List.generate(4, (i) => Expanded(
              child: Container(margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(color: const Color(0xFF4A90E2), borderRadius: BorderRadius.circular(3))))))),
          Positioned(left: 8, top: 22, bottom: 40,
            child: Container(width: 12, decoration: BoxDecoration(color: const Color(0xFF4A90E2), borderRadius: BorderRadius.circular(3)))),
          Positioned(left: 22, bottom: 5, child: _wheel()),
          Positioned(right: 22, bottom: 5, child: _wheel()),
        ])));
  }
  Widget _wheel() => Container(width: 20, height: 20,
    decoration: BoxDecoration(color: const Color(0xFF1A1B26), shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade500, width: 3)));
}

class ScooterWidget extends StatelessWidget {
  final double scale;
  const ScooterWidget({super.key, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(scale: scale,
      child: SizedBox(width: 80, height: 70,
        child: Stack(children: [
          Positioned(left: 15, top: 30, right: 15, bottom: 20,
            child: Container(decoration: BoxDecoration(color: AppTheme.red, borderRadius: BorderRadius.circular(8)))),
          Positioned(left: 5, top: 25, bottom: 35, child: Container(width: 3, height: 20, color: const Color(0xFF1A1B26))),
          Positioned(right: 5, top: 5,
            child: Container(width: 30, height: 30,
              decoration: BoxDecoration(color: const Color(0xFFD4A574), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFF8B6F47), width: 1)),
              child: const Center(child: Icon(Icons.inventory_2, color: Color(0xFF8B6F47), size: 16)))),
          Positioned(left: 12, bottom: 5, child: _wheel()),
          Positioned(right: 12, bottom: 5, child: _wheel()),
        ])));
  }
  Widget _wheel() => Container(width: 16, height: 16,
    decoration: BoxDecoration(color: const Color(0xFF1A1B26), shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade500, width: 2)));
}

class TruckWidget extends StatelessWidget {
  final double scale;
  const TruckWidget({super.key, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(scale: scale,
      child: SizedBox(width: 130, height: 75,
        child: Stack(children: [
          Positioned(left: 5, top: 15, right: 45, bottom: 15,
            child: Container(decoration: BoxDecoration(color: AppTheme.red, borderRadius: BorderRadius.circular(6)))),
          Positioned(right: 5, top: 25, bottom: 15,
            child: Container(width: 45, decoration: BoxDecoration(color: const Color(0xFF1A1B26), borderRadius: BorderRadius.circular(6)))),
          Positioned(right: 10, top: 30, bottom: 45,
            child: Container(width: 20, decoration: BoxDecoration(color: const Color(0xFF4A90E2), borderRadius: BorderRadius.circular(3)))),
          const Positioned(left: 20, top: 35,
            child: Text('Super-Jeeb', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))),
          Positioned(right: 20, bottom: 5, child: _wheel()),
          Positioned(left: 20, bottom: 5, child: _wheel()),
        ])));
  }
  Widget _wheel() => Container(width: 20, height: 20,
    decoration: BoxDecoration(color: const Color(0xFF1A1B26), shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade500, width: 3)));
}
