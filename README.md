- Fase 1: Incluye modelos, autenticación, turnos básicos.
- Fase 2: CRUD para turnos, vistas con Bootstrap y calendario interactivo para pacientes.
- Fase 3: Dashboard para admin, alta/baja de pacientes, ajustes para clínicas, y Cloudinary.
- Fase 4: Ajustes en modelos y vistas para múltiples odontólogos y secretarios.
- Fase 5: Configuración de clínicas y asignación de odontólogos
  - Una clínica con 3 odontólogos y una secretaria, con 10 15 pacientes por profesional.
  - Una clinica con 1 odontologo con secretaria y 10 15 pacientes.
  - Una clinica con 1 odontologo sin secretaria y 10 15 pacientes.
- Fase 6: Login con Google, emails, Google Calendar/Maps, Stripe.
- Fase 7: Despliegue en Render
- Fase 8: Modelo y CRUD para insumos.
- Fase 9: Generalización para oftalmología u otros.

# controllers
- users/omniauth_callbacks_controller.rb
- admin_dashboards_controller.rb
- application_controller.rb
- appointment_controller.rb
- clinics_controller.rb
- home_controller.rb
- patients_controller.rb
- professionals_controller.rb
- secretaries_controller.rb

# models
- application_record.rb
- appointment.rb
- clinic.rb
- patient.rb
- professional.rb
- professionals_secretary.rb
- user.rb

# views
- admin_dashboard
- appointmnet_mailer
- appointments
- clinics
- devise
- home
- layouts
- patients
- professionals
- secretaries
- users

-----------

# Descripcion
DocSync es una app de gestión de Clínicas odontológicas (en principio), íntegramente desarrollada con Ruby on Rails, Bootstrap y PostgreSQL. La misma cuenta con CRUD's de 'appointments (con soft delete), pacients, clinics, professionals, secretaries' y admin dashborad para estadísticas además cuenta con soft delete para appointments, diferentes permisos para sus diferentes grupos de usuarios 'admin, professionals, secretaries, patients', todos sus ID's son UUID para mayor seguridad de datos sensibles, los pacientes son ingresados en el sistema por el admin o la secretaria pero luego tienen la posibilidad de ingresar con sus credenciales de Google y estas se sincronizan con los datos ingresados en sistema, los turnos tienen diferentes estados 'pending, confirmed, completed, cancelled', cuando el turno se crea en pending y pasa a confirmed o directamente se crea en confirmed se envía un email con los detalles del mismo y links a Google Calendar, para agregar el turno y que te avise para no olvidarlo y Google Maps para saber exactamente como llegar desde la ubicación actual del paciente hasta la clínica, a las casillas de email de los pacientes. Appointments y Pacients cuentan con paginado y diferentes filtros y los Patients tienen la posibilidad de agregar una foto que los represente en la app mediante Cloudinary además de todo esto mediante la app se puede abonar el servicio mediante Stripe.

# Pendientes:
01. Asegurarse del pago completo en producción en Render. 
02. Una vez que el turno pasa a completed envío de email con detalle de lo hecho en el turno, receta si es necesario y botón de pago del mismo.
03. Fortalecer el dashboard
04. Analizar si es conveniente que al cerrar pestaña inmediatamente se cierre la cuenta.
05. Analizar si es buena idea que el paciente mismo vea los turnos disponibles de su profesional y pueda elegir el dia y horario de su proximo turno.
06. Arreglar el sistema para vista desde smartphone o pantallas pequeñas.
07. Agregar CRUD de gestión de insumos.
08. Agregar otras disciplinas, psicología, oftalmología, médicos clínicos por citar algunos.
09. Chatbot de ayuda a pacientes en la app.
10. Chat paciente secretaria para consultas varias.

La idea es terminar todos estos pendientes antes de 2025-04-15 (a un mes justo desde el comienzo), lo crees posible?
El MVP ya esta completo. La idea es trabajar a partir de alli sin hacer grandes cambios en la base, a menos que sean extrictamente necesario, que anda bien sino sumar caracteristicas.

# Completos: 01, 02, 03, 04, 05, 06, 08

-----------
