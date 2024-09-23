import 'package:flutter/material.dart';
import 'package:katswiri/screens/webview_screen.dart';

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
                text: 'Version 1.1.4\n',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12.0,
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
          icon: Icons.info,
          title: 'Website',
          subtitle: 'Visit the Katswiri website',
          onTap: () {
            Navigator.pushNamed(
              context,
              WebViewScreen.route,
              arguments: {
                'url': 'https://doreanbyte.github.io/katswiriapp/',
                'title': 'Katswiri'
              },
            );
          },
        ),
        _InformationButton(
          icon: Icons.star,
          title: 'Star',
          subtitle: 'Give the project a star on Github',
          onTap: () {
            Navigator.pushNamed(
              context,
              WebViewScreen.route,
              arguments: {
                'title': 'Katswiri Github',
                'url': 'https://github.com/doreanbyte/katswiri',
              },
            );
          },
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
