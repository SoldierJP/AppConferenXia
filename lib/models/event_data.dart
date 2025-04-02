import 'event_model.dart';

final List<Event> events = [
  Event(
    id: '1',
    title: 'Concierto de la Orquesta Sinfónica Uninorte',
    imageUrl: 'https://picsum.photos/400/200?random=1',
    description:
        'Disfruta de un concierto magistral de la Orquesta Sinfónica de la Universidad del Norte. Repertorio clásico y contemporáneo bajo la dirección del maestro invitado internacional.',
    date: DateTime(2025, 6, 15),
    time: '17:00 - 19:00 hrs',
    location: 'Auditorio Marvel Moreno - Universidad del Norte',
    totalCapacity: 150,
  ),
  Event(
    id: '2',
    title: 'Feria de Innovación Tecnológica Uninorte',
    imageUrl: 'https://picsum.photos/400/200?random=2',
    description:
        'Presentación de proyectos innovadores desarrollados por estudiantes de Ingeniería de Sistemas y Electrónica. Demostraciones en vivo de robótica, IA y desarrollo de software.',
    date: DateTime(2025, 7, 10),
    time: '10:00 - 18:00 hrs',
    location: 'Coliseo Los Fundadores - Universidad del Norte',
    totalCapacity: 20,
  ),
  Event(
    id: '3',
    title: 'Taller de Desarrollo Móvil con Flutter',
    imageUrl: 'https://picsum.photos/400/200?random=3',
    description:
        'Taller práctico organizado por el Departamento de Ingeniería de Sistemas. Aprende desarrollo móvil multiplataforma con expertos de la industria y profesores Uninorte.',
    date: DateTime(2025, 5, 20),
    time: '09:00 - 13:00 hrs',
    location: 'Virtual - Plataforma Microsoft Teams',
    totalCapacity: 30,
  ),
  Event(
    id: '4',
    title: 'Exposición de Arte Moderno',
    imageUrl: 'https://picsum.photos/400/200?random=4',
    description:
        'Una colección impresionante de obras de arte moderno de artistas emergentes y consagrados. Incluye pintura, escultura e instalaciones interactivas.',
    date: DateTime(2025, 8, 5),
    time: '11:00 - 19:00 hrs',
    location: 'Museo de Arte Contemporáneo',
    totalCapacity: 300,
  ),
  Event(
    id: '5',
    title: 'Maratón de Programación Uninorte',
    imageUrl: 'https://picsum.photos/400/200?random=5',
    description:
        'Competencia anual de programación para estudiantes. Resuelve desafíos algorítmicos en equipos de 3 personas. Premios para los primeros lugares y oportunidades de prácticas profesionales.',
    date: DateTime(2025, 9, 12),
    time: '07:00 - 12:00 hrs',
    location: 'SDU1 - Bloque C',
    totalCapacity: 30,
  ),
];
