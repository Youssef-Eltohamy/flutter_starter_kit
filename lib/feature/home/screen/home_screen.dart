import 'package:flutter/material.dart';
import 'package:nemo/res/app_colors.dart';
import 'package:nemo/res/text_style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Back button and title
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 24,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Contact us',
                          style: AppTextStyles.headline3.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Subtitle
                    Text(
                      "Don't hesitate to contact us whether you have a suggestion on our improvement, a complain to discuss or an issue to solve.",
                      style: AppTextStyles.field2.copyWith(
                        color: AppColors.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Call us and Email us cards
                    Row(
                      children: [
                        Expanded(
                          child: _ContactCard(
                            icon: Icons.call,
                            title: 'Call us',
                            subtitle: 'Our team is on the line',
                            time: 'Mon-Fri  •  9-17',
                          ),
                        ),
                        const SizedBox(width: 17),
                        Expanded(
                          child: _ContactCard(
                            icon: Icons.mail,
                            title: 'Email us',
                            subtitle: 'Our team is on the line',
                            time: 'Mon-Fri  •  9-17',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    // Contact us on Social Media
                    Text(
                      'Contact us on Social Media',
                      style: AppTextStyles.field2.copyWith(
                        color: AppColors.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _SocialMediaButton(
                          icon: Icons.chat,
                          label: 'WhatsApp',
                          onTap: () {},
                        ),
                        const SizedBox(height: 16),
                        _SocialMediaButton(
                          icon: Icons.facebook,
                          label: 'Facebook',
                          onTap: () {},
                        ),
                        const SizedBox(height: 16),
                        _SocialMediaButton(
                          icon: Icons.camera_alt,
                          label: 'Instagram',
                          onTap: () {},
                        ),
                        const SizedBox(height: 16),
                        _SocialMediaButton(
                          icon: Icons.send,
                          label: 'Telegram',
                          onTap: () {},
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: AppColors.onPrimary,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: AppTextStyles.action2.copyWith(
              color: AppColors.onPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: subtitle,
                  style: AppTextStyles.field2.copyWith(
                    color: AppColors.appBarTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: '\n$time',
                  style: AppTextStyles.field2.copyWith(
                    color: AppColors.appBarTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SocialMediaButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialMediaButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.surface,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                size: 16,
                color: AppColors.onPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.action3.copyWith(
                color: AppColors.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
