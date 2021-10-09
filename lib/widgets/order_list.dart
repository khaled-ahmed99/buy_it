import 'package:buy_it/models/order.dart';
import 'package:buy_it/screens/admin/orderDetails_screen.dart';
import 'package:buy_it/services/auth.dart';
import 'package:buy_it/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'myPopupMenuItem.dart';

class OrderList extends StatefulWidget {
  final Size size;
  final bool isAdmin;

  OrderList({this.size, this.isAdmin});

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  User loggedUser;
  @override
  void initState() {
    loggedUser = Auth.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Store.loadOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            );
          List<Order> orders = [];
          for (DocumentSnapshot doc in snapshot.data.docs) {
            var order = doc.data();
            if (widget.isAdmin)
              orders.add(Order(
                docId: doc.id,
                email: order[kEmail],
                address: order[kAddress],
                totalPrice: order[kTotalPrice],
              ));
            else {
              if (order[kEmail] == loggedUser.email) {
                orders.add(Order(
                  docId: doc.id,
                  email: order[kEmail],
                  address: order[kAddress],
                  totalPrice: order[kTotalPrice],
                ));
              }
            }
          }
          orders.sort((a, b) => a.email.compareTo(b.email));
          return orders.isEmpty
              ? Center(
                  child: Text(
                  'No Orders Added',
                  style: Theme.of(context).textTheme.headline6,
                ))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: widget.isAdmin
                          ? GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, OrderDetailsScreen.id,
                                  arguments: orders[index].docId),
                              child: OrderView(
                                  isAdmin: widget.isAdmin,
                                  size: widget.size,
                                  order: orders[index]),
                            )
                          : GestureDetector(
                              onTapUp: (details) async {
                                double dx, dy, dx2, dy2;
                                dx = details.globalPosition.dx;
                                dy = details.globalPosition.dy;
                                dx2 = widget.size.width -
                                    details.globalPosition.dx;
                                dy2 = widget.size.height -
                                    details.globalPosition.dx;
                                await showMenu(
                                    context: context,
                                    position:
                                        RelativeRect.fromLTRB(dx, dy, dx2, dy2),
                                    items: [
                                      MyPopupMenuItem(
                                        child: Text('View'),
                                        onClick: () {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(
                                              context, OrderDetailsScreen.id,
                                              arguments: orders[index].docId);
                                        },
                                      ),
                                      MyPopupMenuItem(
                                        child: Text('Delete'),
                                        onClick: () {
                                          Navigator.pop(context);
                                          Store.deleteOrder(
                                              orders[index].docId);
                                        },
                                      ),
                                    ]);
                              },
                              child: OrderView(
                                  isAdmin: widget.isAdmin,
                                  size: widget.size,
                                  order: orders[index]),
                            ),
                    );
                  },
                );
        });
  }
}

class OrderView extends StatelessWidget {
  const OrderView({
    Key key,
    @required this.isAdmin,
    @required this.size,
    @required this.order,
  }) : super(key: key);

  final bool isAdmin;
  final Size size;
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isAdmin ? kSecondaryColor : kMainColor,
      height: size.height * .2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TotalPrice: ${order.totalPrice}\$',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              'Address: ${order.address}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              'Email: ${order.email}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
