import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/domain/model/profile/profile_entity.dart';
import '/new_code/common/profile_image.dart';

import '../../../../new_code/auth/auth_gate_cubit.dart';
import '../../../colors.dart';

class ProfileCard extends StatelessWidget {
  final ProfileEntity profile;
  final bool withLogout;

  /// if set, phone number will be displayed instead of about
  final String? phone;

  ProfileCard({Key? key, required this.profile, required this.withLogout, this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: Container(
          width: double.infinity,
          height: 90,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 0, 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ProfileImage(profile: profile, size: 60),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 10, 0, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Text(
                            profile.name ?? "",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: 'GloryMedium',
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            phone != null ? phone! : profile.about.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: color_99,
                              fontSize: 13,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: withLogout ? LogoutButton() : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.clear(); // TODO: this is dangerous for possibly other features of the app
        context.read<AuthGateCubit>().refresh();
      },
      child: Align(
        alignment: AlignmentDirectional(0, 0),
        child: SvgPicture.asset(
          'assets/images/icons_profile/ic_logout.svg',
          width: 20,
          height: 19,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
