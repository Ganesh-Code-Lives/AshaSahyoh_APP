import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HospitalLocator extends StatelessWidget {
  final VoidCallback onBack;

  const HospitalLocator({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FC), // Brand background
      body: Stack(
        children: [
          Column(
            children: [
              // --- 1. Map Section (Top 42%) ---
              Expanded(
                flex: 42,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Simulated Map Background
                      Container(
                        color: const Color(0xFFE5E7EB), // Map gray base
                        child: CustomPaint(
                          painter: _MapGridPainter(),
                        ),
                      ),
                      
                      // Map Pins
                      const _MapPin(top: 120, left: 80, color: Color(0xFFEF4444)), // Emergency Red
                      const _MapPin(bottom: 100, right: 60, color: AppTheme.primary), // Purple
                      const _MapPin(top: 180, right: 140, color: Color(0xFF10B981)), // Green (Clinic)

                      // Header Overlay
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SafeArea(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: onBack,
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      shape: BoxShape.circle,
                                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                    ),
                                    child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1F2937), size: 20),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {},
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      shape: BoxShape.circle,
                                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                    ),
                                    child: const Icon(Icons.filter_list_rounded, color: AppTheme.primary, size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Floating Map Controls (Right Side)
                      Positioned(
                        right: 16,
                        bottom: 32,
                        child: Column(
                          children: [
                            _MapControlButton(icon: Icons.my_location_rounded, onTap: () {}),
                            const SizedBox(height: 12),
                            _MapControlButton(icon: Icons.add_rounded, onTap: () {}),
                            const SizedBox(height: 12),
                            _MapControlButton(icon: Icons.remove_rounded, onTap: () {}),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- 2. Hospital List Section (Bottom 58%) ---
              Expanded(
                flex: 58,
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFF8F6FC),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                        child: Row(
                          children: [
                            const Text(
                              'Nearby Hospitals',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937), // Charcoal
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'View All',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          children: const [
                            _HospitalCard(
                              name: 'City General Hospital',
                              distance: '2.5 km',
                              address: '123 Health St, Medtown',
                              rating: 4.8,
                              isOpen: true,
                              facilities: ['Emergency', 'ICU', 'Pharmacy'],
                            ),
                            SizedBox(height: 16),
                            _HospitalCard(
                              name: 'Community Health Center',
                              distance: '3.1 km',
                              address: '456 Care Ave, Wellsville',
                              rating: 4.2,
                              isOpen: true,
                              facilities: ['General', 'Pediatrics'],
                            ),
                            SizedBox(height: 16),
                            _HospitalCard(
                              name: 'Saint Jude Institute',
                              distance: '4.8 km',
                              address: '789 Hope Blvd, Cityview',
                              rating: 4.9,
                              isOpen: false,
                              facilities: ['Cardiology', 'Surgery', 'Labs'],
                            ),
                            SizedBox(height: 100), // Bottom padding for FAB
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // --- 3. Floating SOS Button ---
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDC2626), Color(0xFFEF4444)], // Red Gradient
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDC2626).withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 4,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () {
                      // Trigger SOS
                    },
                    customBorder: const CircleBorder(),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sos_rounded, color: Colors.white, size: 28),
                        Text(
                          "SOS",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Helper Widgets ---

class _MapPin extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final Color color;

  const _MapPin({this.top, this.left, this.right, this.bottom, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on_rounded, color: color, size: 40),
          Container(
            width: 12,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapControlButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Icon(icon, color: AppTheme.primary, size: 24),
        ),
      ),
    );
  }
}

class _HospitalCard extends StatelessWidget {
  final String name;
  final String distance;
  final String address;
  final double rating;
  final bool isOpen;
  final List<String> facilities;

  const _HospitalCard({
    required this.name,
    required this.distance,
    required this.address,
    required this.rating,
    required this.isOpen,
    required this.facilities,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A1B9A).withOpacity(0.05), // Subtle purple shadow
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Name + Rating
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        address,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB), // Light Yellow
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFEF3C7)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB45309),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),

            // Middle Row: Distance Badge + Facilities
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF), // Light Purple
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.near_me_rounded, color: AppTheme.primary, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: facilities.map((f) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          "• $f",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      )).toList(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const SizedBox(height: 12),

            // Bottom Buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, Color(0xFF8B5CF6)],
                      ),
                      boxShadow: [
                         BoxShadow(
                          color: AppTheme.primary.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.directions_rounded, size: 18, color: Colors.white),
                      label: const Text(
                        'Navigate',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.call_rounded, size: 18, color: AppTheme.primary),
                      label: const Text('Call'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                        side: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Simple CustomPainter to draw a grid on the simulated map
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const double gridSize = 40.0;
    
    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw some random "roads"
    final roadPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.4, size.width, size.height * 0.6);
    
    path.moveTo(size.width * 0.3, 0);
    path.lineTo(size.width * 0.3, size.height);

    canvas.drawPath(path, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
