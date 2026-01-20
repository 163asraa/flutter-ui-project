// // import 'package:flutter/material.dart';
// // import '../models/message.dart';
// // import '../theme/app_theme.dart';
// // import 'package:provider/provider.dart';
// // import '../providers/auth_provider.dart';
// // import 'package:intl/intl.dart';

// // class MessageBubble extends StatelessWidget {
// //   final Message message;

// //   const MessageBubble({Key? key, required this.message}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     final authProvider = Provider.of<AuthProvider>(context);
// //     final isMe = message.sender == authProvider.username;

// //     return Padding(
// //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// //       child: Column(
// //         crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
// //         children: [
// //           if (!isMe)
// //             Padding(
// //               padding: const EdgeInsets.only(left: 48, bottom: 4),
// //               child: Text(
// //                 message.sender,
// //                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
// //                   color: AppTheme.subtitleColor,
// //                 ),
// //               ),
// //             ),
// //           Row(
// //             mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
// //             crossAxisAlignment: CrossAxisAlignment.end,
// //             children: [
// //               if (!isMe) ...[
// //                 CircleAvatar(
// //                   radius: 16,
// //                   backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
// //                   child: Text(
// //                     message.sender.isNotEmpty ? message.sender[0].toUpperCase() : '?',
// //                     style: TextStyle(
// //                       color: AppTheme.primaryColor,
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 14,
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(width: 8),
// //               ],
// //               Flexible(
// //                 child: Container(
// //                   constraints: BoxConstraints(
// //                     maxWidth: MediaQuery.of(context).size.width * 0.7,
// //                   ),
// //                   decoration: BoxDecoration(
// //                     gradient: isMe ? AppTheme.gradientPrimary : null,
// //                     color: isMe ? null : Colors.white,
// //                     borderRadius: BorderRadius.only(
// //                       topLeft: Radius.circular(20),
// //                       topRight: Radius.circular(20),
// //                       bottomLeft: Radius.circular(isMe ? 20 : 4),
// //                       bottomRight: Radius.circular(isMe ? 4 : 20),
// //                     ),
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: isMe
// //                             ? AppTheme.primaryColor.withOpacity(0.3)
// //                             : Colors.black.withOpacity(0.05),
// //                         blurRadius: 8,
// //                         offset: Offset(0, 4),
// //                       ),
// //                     ],
// //                   ),
// //                   padding: EdgeInsets.all(12),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         message.content,
// //                         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
// //                           color: isMe ? Colors.white : AppTheme.textColor,
// //                         ),
// //                       ),
// //                       SizedBox(height: 4),
// //                       Row(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Text(
// //                             DateFormat('HH:mm').format(DateTime.parse(message.timestamp)),
// //                             style: Theme.of(context).textTheme.bodySmall?.copyWith(
// //                               color: isMe ? Colors.white70 : AppTheme.subtitleColor,
// //                             ),
// //                           ),
// //                           if (isMe) ...[
// //                             SizedBox(width: 4),
// //                             Icon(
// //                               Icons.done_all,
// //                               size: 14,
// //                               color: Colors.white70,
// //                             ),
// //                           ],
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               if (isMe) ...[
// //                 SizedBox(width: 8),
// //                 CircleAvatar(
// //                   radius: 16,
// //                   backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
// //                   child: Text(
// //                     message.sender.isNotEmpty ? message.sender[0].toUpperCase() : '?',
// //                     style: TextStyle(
// //                       color: AppTheme.primaryColor,
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 14,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import '../models/message.dart';
// import '../theme/app_theme.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import 'package:intl/intl.dart';

// class MessageBubble extends StatelessWidget {
//   final Message message;

//   const MessageBubble({Key? key, required this.message}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final isMe = message.sender == authProvider.username;

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       child: Column(
//         crossAxisAlignment:
//             isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           if (!isMe)
//             Padding(
//               padding: const EdgeInsets.only(left: 48, bottom: 4),
//               child: Text(
//                 message.sender,
//                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: AppTheme.subtitleColor,
//                     ),
//               ),
//             ),
//           Row(
//             mainAxisAlignment:
//                 isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               if (!isMe)
//                 CircleAvatar(
//                   radius: 16,
//                   backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
//                   child: Text(
//                     message.sender.isNotEmpty
//                         ? message.sender[0].toUpperCase()
//                         : '?',
//                     style: TextStyle(
//                       color: AppTheme.primaryColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               if (!isMe) SizedBox(width: 8),
//               Flexible(
//                 child: Container(
//                   constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.7,
//                   ),
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: isMe ? AppTheme.primaryColor : Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20),
//                       bottomLeft: Radius.circular(isMe ? 20 : 4),
//                       bottomRight: Radius.circular(isMe ? 4 : 20),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: isMe
//                             ? AppTheme.primaryColor.withOpacity(0.3)
//                             : Colors.black.withOpacity(0.05),
//                         blurRadius: 8,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         message.content,
//                         style:
//                             Theme.of(context).textTheme.bodyLarge?.copyWith(
//                                   color: isMe
//                                       ? Colors.white
//                                       : AppTheme.textColor,
//                                 ),
//                       ),
//                       SizedBox(height: 4),
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             DateFormat('HH:mm')
//                                 .format(DateTime.parse(message.timestamp)),
//                             style:
//                                 Theme.of(context).textTheme.bodySmall?.copyWith(
//                                       color: isMe
//                                           ? Colors.white70
//                                           : AppTheme.subtitleColor,
//                                     ),
//                           ),
//                           if (isMe) ...[
//                             SizedBox(width: 4),
//                             Icon(
//                               Icons.done_all,
//                               size: 14,
//                               color: Colors.white70,
//                             ),
//                           ],
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               if (isMe) SizedBox(width: 8),
//               if (isMe)
//                 CircleAvatar(
//                   radius: 16,
//                   backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
//                   child: Text(
//                     message.sender.isNotEmpty
//                         ? message.sender[0].toUpperCase()
//                         : '?',
//                     style: TextStyle(
//                       color: AppTheme.primaryColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
 
import 'package:flutter/material.dart';
import '../models/message.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
class MessageBubble extends StatelessWidget {
  final Message message;

  /// ⚡️ أضفنا حالة الاتصال هنا
  final bool isSenderOnline;

  const MessageBubble({
    Key? key,
    required this.message,
    this.isSenderOnline = false, // القيمة الافتراضية false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isMe = message.sender == authProvider.username;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(left: 48, bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    message.sender,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.subtitleColor,
                        ),
                  ),
                  SizedBox(width: 6),
                  // ⚡️ عرض نقطة الحالة (دائرة صغيرة) بجانب الاسم إذا متصل
                  if (isSenderOnline)
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Text(
                    message.sender.isNotEmpty
                        ? message.sender[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  decoration: BoxDecoration(
                    gradient: isMe ? AppTheme.gradientPrimary : null,
                    color: isMe ? null : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(isMe ? 20 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isMe
                            ? AppTheme.primaryColor.withOpacity(0.3)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.content,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: isMe ? Colors.white : AppTheme.textColor,
                            ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                       
                          if (isMe) ...[
                            SizedBox(width: 4),
                            Icon(
                              Icons.done_all,
                              size: 14,
                              color: Colors.white70,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (isMe) ...[
                SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Text(
                    message.sender.isNotEmpty ? message.sender[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
