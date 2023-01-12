import 'package:flutter/material.dart';
// import 'package:flutter_application_1/pages/navpages/search.dart';

AppBar searchbar(BuildContext context) {
  const icon = Icons.mic;
  return AppBar(
    automaticallyImplyLeading: false,
    elevation: 0,
    backgroundColor: Colors.transparent,
    // ignore: prefer_const_constructors
    title: Center(
        // child: TextField(
        //   decoration: InputDecoration(
        //     hintText: 'Search for vacay homes, spaces...',
        //     suffixIcon: IconButton(
        //       onPressed: () {},
        //       icon: Icon(icon),
        //       color: Colors.cyan,
        //     ),
        //   ),
        // ),
        child: Container(
      height: 60,
      padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
      // child: GestureDetector(
      //   onTap: (){
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
      //   },
      //   child: Container(
      //     decoration: BoxDecoration(
      //       border: Border.all(color: Colors.cyan, width: 4, style: BorderStyle.solid),
      //       borderRadius: BorderRadius.circular(8),
      //     ),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: const  [
      //         Icon(Icons.search),
      //         Text('search for homes, rooms, apartments', overflow: TextOverflow.ellipsis,),
      //         Icon(Icons.mic)
      //       ],
      //     ),
      //   ),
      // ),
      child: GestureDetector(
        onTap: () {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => const SearchPage()));
        },
        child: TextFormField(
            decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyan)),
          hintText: 'Search for homes, spaces...',
          hintStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          prefixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          suffixIcon: IconButton(onPressed: () {}, icon: const Icon(icon)),
        )),
      ),
    )),
  );
}

