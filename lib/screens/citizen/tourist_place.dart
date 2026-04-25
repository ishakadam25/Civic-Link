import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';

class TouristPlaceScreen extends StatefulWidget {
  const TouristPlaceScreen({super.key});

  @override
  State<TouristPlaceScreen> createState() => _TouristPlaceScreenState();
}

class _TouristPlaceScreenState extends State<TouristPlaceScreen> {
  String selectedArea = "All";
  String searchQuery = "";

  final List<String> areas = ["All", "Colaba", "Bandra", "Juhu", "Dadar", "Andheri", "Kurla"];

  final List<Map<String, String>> touristPlaces = [
    {
      "name": "Gateway of India",
      "area": "Colaba",
      "image": "https://live.staticflickr.com/7229/7060979299_c58c20e52c_b.jpg",
      "location": "https://maps.google.com/?q=Gateway+of+India"
    },
    {
      "name": "Bandra Bandstand",
      "area": "Bandra",
      "image": "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxISEhUPEhIVFRUVFRUVFRYYFRUVFRYVFRUWFhUVFRUYHSggGBolGxUVITEhJSkrLi4uFx8zODMtNygtLisBCgoKDg0OFxAQGi0fHR0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIAKgBLAMBIgACEQEDEQH/xAAaAAACAwEBAAAAAAAAAAAAAAACAwEEBQAG/8QAPxAAAQMCAwUFBQYGAgEFAAAAAQACEQMhBBIxBUFRYXETIoGRoQaxwdHwFDJCUnLhFRYjYoKSM1PSQ2Oio7L/xAAYAQEBAQEBAAAAAAAAAAAAAAACAQADBP/EACQRAAMBAAICAgICAwAAAAAAAAABEQIDEiExQVETkaHRBEJh/9oADAMBAAIRAxEAPwDWCY1LamBGkgYTAlhMClLAwjCAIwpTQMIghCMLUsCCMIQjClLAgEQCgIwFKWEgIgFwCMBGihACINRAIg1TsXqBlXZU0NU5VOxeomF2VOyqMq3YnUQWoSE8tQlqvY3UQQhITSEBCVDBRCAppCWVaSAFAUZQFWkgBS3JhQOVpILIQFMKWVqSAOS3I3FLcVaSAuSnI3JblqaAkoFLkMqmhZaUxpSWlMaUKODgmApLSmAo00GgowlAowVqWDQUYSmlMapSwYExqU1MaVKWDAmNS2prUaJINoTGhA1OaEWxQ4NTA1c0JrQi9CgIapypgaiyqdjQTlQlqeWoS1bsaFchAQnuCW4KrRIIcEshOclOTTJBTkBTHJTlaFoByAonJbkqGAuS3FGUty1JAHIHInJbirSQEpZRuKW4q0kAcluRuKU4q00BcgKlxQSrSQsNKY0quHJgcgOFhpTAVWa5Ma5GlhYDkYKrhyMOUpYWAUxpVcPRhylFCy0pjSqrXJrXKUqRZaU1pVVrk5jkWxpFphTmqsxyintCmav2cPBqhmcsFyGSBLuEkiJ1vwQehdTQYE9jUimrTAub0WBBqKFLQmBqPYjYktQParBaluC3YydKrgkPCtVFWqFNaL1EvSnFG9yS5ya0R5BcUpxUuclOcmtAaIcUtxUuclOclQw5xQOKhzktzlqSEuKW4qHOS3OVoYS4pbioc5Lc5WkhLilOK5zktzkiQ5xQZlDnIMyphgejD1Ua9GHrNCLjXow9Uw9GHotFRcD0bXqmHow9GCLrXo2vVMPRh6LEkXWvTWvVFtRNbURYki816ax6oNqJzKiDEkX2mbcVl+y2w/srsTUc4OfXrvqSJtT/APTpmdconpMBW2VFYp1FzemlDokatJ6uUysmlUV+hUXn1orz4NGkFYDUjDFXGNVwnvUyePkcYio1VaivVAs+uUW2nGPj8leqVTqOTa71SqPSzo9XUh70h71D3pD3rumBoJz0pz0DqiU566IDQxzktz0t1RKdUTQYNc5Lc9KdUS3PVC0Nc9Lc9Kc9Lc9II1z0tz0tz0svSSIxhegc5Lc9LL0kgjHOS86AvQF6UISHIw5VwUQcnA0shyIOVcORByLQqWQ9GHqqHIw5FoSZaD0xr1TDkYci8iTLgemNeqYeja5F5GmXW1E1tRUWvTG1FzeRpmgyon06qzG1E1tRctZOiZsUqyu0MQsBlZWKeIXn3xnRM9RhsWtOlixErx1LFK2MdbVcV3w7kG+HOjfxGNCzMRi1m1MZzVapiVlht1izx5z6LdbEKpUrqs+ukOqr0ZwZssPrJLqqQ6olOeu6yc2x7qqW6okOegc9dFk5tjXVEtz0ouQF6ayFsaXpbnpZcgL0uoGxhegL0pzkJckkGjHPSy9AXIC5KEoZcgc5AXIS5WBoRcgzISUMpQlDBRByw8zuPqpzO/N6lOApu5kQcsQOO8+qnPukz4/BRotNsORhywszuKYJ4nzUhexthyMOWGCeM+KlhJ3/AB9UeouxvByNr1hNDuPrqjDXcfrzU6i7G6How9YbWOiZhGAePS6DyJbNxr0wVFg5HjcZ4bvNFDvhvnrE3ReENbPQNqJjaq8812/MI11Om9C3ENzRnA8THnGq5vjGtnqG1kz7QvOUawJgE9Yd0/KtKngXmYcIEcZPnAXDeVn2dc6bL5rpbqyy69KJEmZ3g3+apucbnraD6E6pZwmTWmjcdVS3VFhX3GeUGfMITTdwnrb4LqsI5vbNt1RAXrEgzEabgb+KAg9B5yuiwc3s2y9AXrFyk/VvRLcLX9DM+cJrIXtm2XoC9YuU8JHUfNLqW8eaSyHsbZegL1hPkWi3UX87ruz1N+kR8FeoextF6AvWGDyPkfkhc6Nfir1D2NwvQF6wy4FQ4b9PAq9SU2y9AXrHLUtzNysJTaL0OdYhCjL9W+aUNS/Tafo2TW0uQ8P3WfW2jlE5b/qHyQ4fariJFMmRIvFj4KvGiLSNcUuAb5/JcxjpuWeBVVm1AR/xvnh+5hMG1B/1v8h8CUJoXge8Cbx6yk16uW5a8jloPcUP8UG6m4+QUu2sP+p/otH9GqBOOA0ZUnwv5lFRxsm7K44/cj0KuUcYxwmHDkQJXHHtBy5H/wCqzX/ComjXa7845GU4OafxO84PSVQrYx1stGf1H9kLcWTbsWg7ocPiEOrF2RoRwe4jhmE+cyjEu3PnSLH46Kg3tDBgcwWM98hP+11R92kw+I+ajyyrSLTmHWHyOYHXkq1LFz3XMzXH46bjzkJP8Urtt9naOkm3IWRUdt1v+qAP7X8OSy49P4/kvfP2Pd2l8jCCeJm/OI05J1JuI3sD7aFr2+RL7XVNm2KxdMEjTKaZHjKaduV2z3Nf/bqHz7x5I64t/S/ZVyY+2MdWxoPcwggb4D/GSQr+HONe3IaLmA2JYwEieLSCOHmsz+ZcVb+lyAFOpBm1wSR5Ky72rxQAblIOkhkER4RPPVctcPI/9c/sa5cr5ZpMwOKIGZ7Q0QSDRpzHgQL33KauzTaxi9oAbGsxP1K8pitu4gOzAkk692Sep3qrW9psS6SXOGgiCB429yq/xuRP2jfnx9M9V2RsCCAN5JmeZ0HgVRxuLeDkMA6gBpcB4iyxG7QxzgMtXL/jLiOF26J9DGYtg79SeRZkHQWiU1xte4F8if2azKr3D7xM6HJBFri5ibJQxBmwc7mRHLcTCy6mIxDyCH79CNPFrdyM18TJguPKYaLbjlJ80lkPYvGtU3U44S4wfikmvWEzS8ZB8blL7PENhwqAk/mBtylrbqalKp94ubPG/ru9EkRs55qEyWuA/WQOlrIn7pZ/9n7IR2n5mx6nhcR7l2d5sYkb9/nYeSoRFWs8EhrJm5moAfCx96Sxz3DvMIHRz9f0kK1Up1Zs5ptwJS6lGqbd2eN1UQr9lcy153avHvKln6L8yLeIJTOxe27gJ5FwCGnSLjIyk7xmOnRUgNakLZmjrJPllCnJlEAW4X9ASiNFw/CLc3+8qHMeT3tOE6eixgA+NWfGOtzCB5Ivld5GPcERYfynrAJ8CpZSkQWu03qkEHNwMfXMqPHzsfKE44UTIDgeTnR5KDg2758grTAY/FPNKp3MvcdcWOh0IFlkYLHVaQkju0A1kE6ZruOtzJHGBaytv2hmYZyjM24kxcXEb9UrD4gQ4wy7y6IkOLs1yT+r0Spkits/br2dqDBLqmYA3AJdNSCN31xTcb7Rua8gU2wHGzm3IgQCf9vRUWURkhwaC0taCNbv7xn9PvKLHUC+9rgXBnQHz+96KGPRbB2mypRBqFgeCQRAbJGhA6R6rT/iFIA6ecz5LzWyKeVmUF7Zue8ACYAJVupiA1zWue+XTlECDFzuWpobR2hT0j3z1WXszaQe0vIuXOGXLIaJMNnfYIqOMGmcj/EfJUsBXDMwZmMmXWIGYi506LVGhuitS/E0HhDfeOKVj69KlkcaQ7zwLsJJbBJiNTYW5pOHrvN8jjzIHxaq+0nPc6kHkgMqU3NERncXgO3DRv8A+jwU7KljNl5a0f8ADP8Ajpy1hIFVsyzDgH9LVPbgd0ho47kP2hpOrT4yRCndl6jvtVcfdpjhbLHjdc3EYk6spjkXAHrokiqzUuj/AC132BTftRNqbSb3Og6Ewi9v6QlktN+06/0x1Jj4SmtGIIzZaJE3Mz8bLNqh9g5zmToZYG/7EFWKNKoILa4No/DPTNHzXLW39o6LK+i/SoYgnKKUH8wkt114hPdhajWd8lnES53oHeOip4V1Zrw4Fo4/1mNn0EcVps2jWmHl9wA2HUDbn3wRqeK82+baftHbPFn6KNKlUnKapAicwZbkGy6/kuOHdp2jjpA7Jp63MBab8ZVG8xwY6k5xi9y58Dcs6ntUzlFB40u51MSZ4NNz1Wzyb158fwV4yhJwNQT/AFKnGwaPc9KxGFqRLahJsbgX8c6tnaDp/wCJxJEyDTkb7XSftT3XNN46uZ7gV1zrXyc3nPwV8tcCwBt+UT0Fyl/aa9yaY83e8D0RvM60yL6tcZgdCJtxVfF7QbSaXOY4NECTmEnc0Hiuvl/Bz8L5Hsxb91G/GXetvVeO9oNsVnVKlAnKx2QFo1EHMY3i62Xe1bQJgA8HFx8ea8rjMSH1jWJaMzjLQIAGWPcnlR+gN+PZtbE2m97yar5ytDWCWga3MGxdpeFZ2ltQtqUW03Ay4yJm8BsOjQQT4idy8/s7GNZq0HvAnW/cgi2658gnYrH03Pp1BSDchuLw64N79fNdIgU9i/FN303+GRx9ClnaDJENf0LSPeYWPS2vQJzGmAeRIPvQV9p0AQcl+PD1KnVGrKmPx7zXlpIio0AEua3LYta5o/Vdegp7Ta6qaTcrobJNrOkAiY56LxWOxAdVFQfmzcTY2HkAEWJrNFZz6XdBjL1IE+spdUam9T9onmtUYRLRmDIy6tkkydZhBsDbr3FzKkvABdnAvc6EcL+iy9nuYH1H1H8hp3gQ5pkdPerWxjTZUlpJHZ97deGbuod5qdUSs0KftA01uyAOUuDQSS2/en1ygDql1faBrarqZnKAR/mDECdQsyrSH2ptQfdNTNpP3Q1xtxmVUx1AOqvc2wJqO04ZyBHPKfNbqi09KNrFzA5sQH5HEmBE6idbQY+SN1SqTr0s4W8l5+nQLaOsntPu7r5W68QZCt4rGva7Kx5iBoeIBuDpqmsJ+gvUMUEj6spaXbj6qIn64LjwsoYnM4iC4+pChwHEqXRyQAfU/JYwynUAs7NHI/UpZIzQ2YsBpPojAjgmHEAVGvyDu5dCdWuDp14WWsKbuytlPqGM5aBoey18bQj2dsR1UOeyqWgOLAS3XLqRfT5J1D2npt1aQN0Dn1Ttj7Uo02ZKcRJ1MRmJIDnHU3PkuTehpZBd7N1zrXHCQSD5wq2L9nHsyRUe4ueGWd92QTNx/avSU9osP4h5/NWW1gdCFz76Q+qMT+VW/wDa+edx5FOo+zAAu+Txgj0BErZD0Yeub3o6LGTHHsswzNR3gBbxMlVm7FqU3nLTquBJuKlKI0uHXHhpC9GKyNtcaI/k38iWM/B5ynsuuGkPa0BxEB2Je0//ABgJ2GwOFENrPot4ZcTVzTEb363HmvQtxAmJHFMDmzJDZ4wPeub5GNYRmYDZeEc7Iyq4mJgVw4nfMEXWo72ZdmzMPdBBymJ4gB0z7k6gGtOYNaDxACzfaH2hxlI5MPh87co/qAZnSSZAbO4ct68+vyacy/2dF1yqx9LYj2955bN7HO8Cd05uuqrn2fpiXACTwaLHlewXmKXtTiAIqUsQ7cJD46Ru66pQ9oq1Sze1F4gTY8NRC9GeLlXtnN8nGzcxFJtOc0jdLGPkabz8Eim6l+ev4iqJ6W6aLI/jldpn+oL3BLniZ0MGOCfT9o3kEu47wSfAZS3rf5Lus7SOT1lnoWUaTRqfEuOvuXlvbKmcjTTJLROYS48MpMk8/NRS2q67mvaTaQXAkn8oG7Xkm4nar3tNPK250AzHpAmSnnOk6DTy0eILzxK4uXqf4EyoczYHeLSHZmGeGkarG2pgRSqGm4QRw7wPj57l2Wkzi0ygHojW+rj4q1gdn9rIa17iInKNJ8Vpt9lakZpjkWq1IkMHtjpJUdotkez5JIFSmYmRN7cpVVuyCZIqUiB/fCtRoZ+dRKvYrAZIlwvwcHeqT2bdLk9IWMA2sRofoaKRWMzmIRCiydXRxDZHwRNyAaPnwjrBCtIAahJmbzxv6Lu0M/v9c0+gaR+/nHNuWR4bwhc3vANIcDvykERxAn4rGGM2gQIid/4d11OMrNcWmJ7oG62trEqfslTg0jScwAtydB9EuphHNMEAf5N+atMVT9WQ+KjOV6al7MMi9RxPIAfNF6hYebHgpleqb7NUvzVPNv8A4ov5bo8X+Yt0sp3RYzyYHJFlMyBA539YXp/5ZpfnqebfkvP7Tw3ZVXUgSQIud8gH66LLSZI0IlyJjnCDprB3JR6qc3NUxcZXqZp7WDrJcQORt0XoNnYuvEiqH8bOI8yPcvKg9Fs7Nw1YwW04EzLpYPDejpKFR6ZuLr8Kbv8Af4NV2jWcR3oB5A/FVsO5wEOIPRN7RednZFttRNbUVAPRNeubQ0yNobUpju91xFzc25jKCSei89T9qajHQTmEmQJga2AeA61tTuVzaOwaVWILmkGdS6ZibO6BU6Hskz8VVxG7K0N85JXTK455C9bvg0sJ7bMjvsfO/Lkj1IWnT9rcM5uZrwD+V/cI66jxWP8Ayrh5n+oOWe3ulNx+w6HYFjWhpaC4PIzOG83sTa2vBB44n9iW9hP9q2Ve0oud2TS1wbUa8TMeY36SvFYmWuAY8lsd0/dJEkaDmCip4TN+JoPOw/2Vas9wOR092RE6b7L0441n0cdbevY9mKqATmIvrf5acpVqltV1gctv7YJvN7848PFZbSefvXdpy9AnAU2W7QvENPA34i3S2/iU9u14EMZH5ogHURkjfx+S88HjkFLav1ErRGrPXUNvOOtQzMfda6L7ysrarm1avaEgGw0OX0Oviso1pH18VBqnfdZYS9GemzXwuMOGzOpyMwDbxc9Q4wNbrNr4iq4klzrmfvW9Sk9oTu8YXTyHWI9yqRKcC7X1UucYiVJYPqyHsx09fcqQgE7hKnt3RHBS1h3AfXVEL6ubbjPwBWhgH155dFBqE/i5b/VWH4Rwi+ughwnzCU+mNDAPAlYoXaMI0v8Aq9bhTRp5jGlrafXEpJo759x9yGCFkZsvVKD47zp6l149EBwj/wAv15J9DaDoHd8rJwxLjeQOouukTDTPoYDNHfYC7QF0eJt4WXtqGUANaIG4Rl9Ny5cuOkNCsXtKnTjMYlOp1g4Bw0IBG435KVyDQic6z8ZgG1KjKhiGzmBE5rd3yMrlyhhgwdLdTZ4NHrCJmGpjSm239o965csYiqxwMsIHFuUX5zuVhlQ79Vy5QwYqKe0ULlIWlaptSk0wXieUn3JuHx9N9mvBPCYPkbrlyTwobsWRVRCquXLlBphdr+6jEucWOa12VxFjAMHoVy5SGp4euwh7gSwkEgkE67wAQN6TUE2IB5yRPmFy5etHErPw7gdPVAaLuHqFK5YhDKd72TDTboJJ8IXLljDqOFabuJA4Ayf29UuoGtdDSd2oB94suXLnlt6Z6+Xjznhy0vL/AKCe+XZoYDwA7ukfdNl1HIQQQQZEGTEbxC5cu6Xk8bOr02iCwzxuPS8+iQ4jmpXLa8GR2Unn5IbhcuRKNqY151ckl83Oq5coYlp+gExjDw8P2ULlTBEncI80dKsQPuz4ke4rlyqIf//Z",
      "location": "https://maps.google.com/?q=Bandra+Bandstand"
    },
    {
      "name": "Juhu Beach",
      "area": "Juhu",
      "image": "https://s7ap1.scene7.com/is/image/incredibleindia/juhu-beach-mumbai-maharashtra-2-musthead-hero?qlt=82&ts=1742167931841",
      "location": "https://maps.google.com/?q=Juhu+Beach"
    },
  ];

  Future<void> openMap(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter places based on selected area and search query
    final filteredPlaces = touristPlaces.where((place) {
      final matchesArea = selectedArea == "All" || place['area'] == selectedArea;
      final matchesSearch = searchQuery.isEmpty ||
          place['name']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          place['area']!.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesArea && matchesSearch;
    }).toList();

    final translations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(translations.t('tourist_spots'))),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Container(
                  height: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?auto=format&fit=crop&w=1200&q=80',
                      ),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 18,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      translations.t('discover_city'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black38, blurRadius: 6)],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: areas.map((area) {
                    final isSelected = selectedArea == area;
                    return ChoiceChip(
                      label: Text(area),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          selectedArea = area;
                        });
                      },
                      selectedColor: Colors.blue.shade100,
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: translations.t('search_hint'),
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFF3B5CE8), width: 1.8),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              filteredPlaces.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: Text(translations.t('no_places_found'))),
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: filteredPlaces.length,
                      itemBuilder: (context, index) {
                        final place = filteredPlaces[index];

                        return GestureDetector(
                          onTap: () {
                            openMap(place['location']!);
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Image.network(
                                        place['image']!,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      left: 16,
                                      bottom: 16,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.55),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          place['area']!,
                                          style: const TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    place['name']!,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}