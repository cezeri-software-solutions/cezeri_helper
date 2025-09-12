import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../classes/cezeri_country.dart';

class CezeriCountryFlag extends StatelessWidget {
  final CezeriCountry country;
  final double? size;

  const CezeriCountryFlag({super.key, required this.country, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: country.name,
      child: CachedNetworkImage(
        imageUrl: country.flagUrl,
        imageBuilder:
            (context, imageProvider) => Container(
              width: size! * 1.5,
              height: size,
              decoration: BoxDecoration(shape: BoxShape.rectangle, image: DecorationImage(image: imageProvider, fit: BoxFit.fitHeight)),
            ),
        placeholder: (context, url) => SizedBox(width: size! * 1.5, height: size, child: const Center(child: CircularProgressIndicator())),
        errorWidget:
            (context, url, error) =>
                Container(width: size! * 1.5, height: size, color: Colors.grey[200], child: Center(child: Text(country.isoCode))),
      ),
    );
  }
}
