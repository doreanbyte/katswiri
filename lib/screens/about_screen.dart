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
                  child: _AppDetailSection(),
                ),
              ),
              Divider(),
              _AdditionalInformationSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppDetailSection extends StatelessWidget {
  const _AppDetailSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
                text: 'by Dorean Byte',
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
        const _SocialButtons(),
      ],
    );
  }
}

class _SocialButtons extends StatelessWidget {
  const _SocialButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _SocialButton(
          icon: Icons.mail_outlined,
          label: 'Email',
          //TODO: Implement onPressed for email social button
          onPressed: () {},
          toolTip: 'Email Dorean Byte',
        ),
        _SocialButton(
          icon: Icons.public_outlined,
          label: 'Website',
          //TODO: Implement onPressed for website visit button
          onPressed: () {},
          toolTip: 'Visit Katswiri Website',
        ),
      ],
    );
  }
}

class _AdditionalInformationSection extends StatelessWidget {
  const _AdditionalInformationSection();

  @override
  Widget build(BuildContext context) {
    return const _InformationButtons();
  }
}

class _InformationButtons extends StatelessWidget {
  const _InformationButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InformationButton(
          icon: Icons.star,
          title: 'Rate',
          subtitle: 'Like the App? Give Us a Rating',
          //TODO: Implement onTap callback for rating
          onTap: () {},
        ),
        _InformationButton(
          icon: Icons.description,
          title: 'Terms of Service/EULA',
          //TODO: Implment on tap for Terms of Services
          onTap: () {},
        ),
        _InformationButton(
          icon: Icons.api,
          title: 'Third-Party Services',
          //TODO: Implement on tap for Third-Party Services
          onTap: () {},
        ),
        _InformationButton(
          icon: Icons.extension,
          title: 'Open Source Licenses',
          onTap: () {
            Navigator.pushNamed(
              context,
              '/license',
            );
          },
        ),
      ],
    );
  }
}

class _InformationButton extends StatelessWidget {
  const _InformationButton({
    required this.icon,
    required this.title,
    this.subtitle = '',
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required IconData icon,
    required String label,
    void Function()? onPressed,
    String? toolTip,
  })  : _iconData = icon,
        _label = label,
        _onPressed = onPressed,
        _toolTip = toolTip;

  final IconData _iconData;
  final String _label;
  final void Function()? _onPressed;
  final String? _toolTip;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          tooltip: _toolTip,
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
