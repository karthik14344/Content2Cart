import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF232F3E), // Dark blue background
      child: Column(
        children: [
          // Top App Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Amazon Logo
                Image.asset('assets/images/amazon_logo.png', height: 32),
                const SizedBox(width: 12),

                // Deliver to location
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: Colors.white),
                      const SizedBox(width: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Deliver to John',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            'Bangalore 560034',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          // All dropdown
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: 'All',
                              underline: const SizedBox(),
                              items: ['All', 'Phone'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (_) {},
                            ),
                          ),

                          // Search input
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search Amazon.in',
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ),

                          // Search icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            color: const Color(0xFFFFBB66), // Amazon orange
                            child: const Icon(Icons.search),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Country flag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Image.asset('assets/images/india_flag.png', height: 20),
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                ),

                // Account & Lists
                InkWell(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Hello, John\nAccounts & Lists',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),

                // Returns & Orders
                InkWell(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Returns\n& Orders',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),

                // Cart
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Image.asset('assets/images/cart_icon.png',
                              height: 32),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF9900),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Cart',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            color: const Color(0xFF232F3E),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {},
                ),
                _buildTab('All'),
                _buildTab('Fashion'),
                _buildTab('Mobiles'),
                _buildTab('Gift Ideas'),
                _buildTab('Prime'),
                _buildTab('Amazon Pay'),
                _buildTab('Gift Cards'),
                _buildTab('Sports, Fitness & Outdoors'),
                _buildTab('Computers'),
                _buildTab('Customer Service'),
                const Spacer(),
                // Prime Video Join Now button
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9900),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/images/prime_logo.png', height: 18),
                      const SizedBox(width: 4),
                      const Text(
                        'JOIN NOW',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () {},
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
