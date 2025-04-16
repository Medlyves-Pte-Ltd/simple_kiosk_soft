// lib/ui/screens/patient_id_input_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';

class PatientIdInputScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  PatientIdInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.enter_id)),
      body: BlocListener<AppointmentBloc, AppointmentState>(
        listener: (context, state) {
          if (state is AppointmentStartSent) {
            Navigator.of(context).pushReplacementNamed('/teleconsultation');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.patient_id),
              ),
              ElevatedButton(
                onPressed: () {
                  // SharedPrefs.setData('patientId', _controller.text);
                  BlocProvider.of<AppointmentBloc>(context).add(SendStartEvent(
                    patientId: _controller.text,
                    kioskId: KioskConfig().kioskId,
                  ));
                },
                child: Text(AppLocalizations.of(context)!.start_tc),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
