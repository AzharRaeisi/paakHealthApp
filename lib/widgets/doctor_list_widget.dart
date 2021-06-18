import 'package:flutter/material.dart';

class DoctorListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Positioned(
          left: 0,
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 100,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:6,
                      itemBuilder: (context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Container(
                            child: Center(
                                child: Text(
                                  'Alpha',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 36.0),
                                )),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
            child: Icon(Icons.arrow_forward_ios))
      ],
    );
  }
}
