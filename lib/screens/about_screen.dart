import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const route = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('About'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: _AppSection(),
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppSection extends StatelessWidget {
  const _AppSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text(
        //   'Katswiri',
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 36,
        //     color: Theme.of(context).colorScheme.primary,
        //   ),
        // ),
        // const SizedBox(
        //   height: 12.0,
        // ),
        // const Text('Version 0.1.0'),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Katswiri\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              TextSpan(
                text: 'Version 0.1.0\n',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              TextSpan(
                text: 'By Dorean Byte',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SocialButton(
              icon: Icons.mail_outlined,
              label: 'Email',
              onPressed: () {},
            ),
            _SocialButton(
              icon: Icons.public_outlined,
              label: 'Website',
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required IconData icon,
    required String label,
    void Function()? onPressed,
  })  : _iconData = icon,
        _label = label,
        _onPressed = onPressed;

  final IconData _iconData;
  final String _label;
  final void Function()? _onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: _onPressed,
          icon: Icon(
            _iconData,
            size: 28,
          ),
        ),
        Text(
          _label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
