// lib/event_data.dart
import 'event_model.dart';

final List<Event> events = [
  Event(
    id: '1',
    title: 'Concierto de Rock',
    imageUrl: 'https://picsum.photos/400/200?random=1',
    description:
        'El mejor concierto de rock del año con bandas internacionales y nacionales. No te pierdas esta experiencia única con los mayores éxitos del rock clásico y moderno.',
    date: DateTime(2023, 6, 15),
    time: '20:00 - 23:00 hrs',
    location: 'Estadio Nacional',
    totalCapacity: 5000,
  ),
  Event(
    id: '2',
    title: 'Feria de Tecnología',
    imageUrl: 'https://picsum.photos/400/200?random=2',
    description:
        'Descubre las últimas innovaciones tecnológicas de las principales empresas del sector. Demostraciones en vivo, charlas con expertos y oportunidades de networking.',
    date: DateTime(2023, 7, 10),
    time: '10:00 - 18:00 hrs',
    location: 'Centro de Convenciones',
    totalCapacity: 2000,
  ),
  Event(
    id: '3',
    title: 'Taller de Flutter Avanzado',
    imageUrl: 'https://picsum.photos/400/200?random=3',
    description:
        'Aprende Flutter con expertos en desarrollo móvil. Este taller cubrirá temas avanzados como gestión de estado, animaciones y integración con backends.',
    date: DateTime(2023, 5, 20),
    time: '09:00 - 13:00 hrs',
    location: 'Coworking Tech',
    totalCapacity: 30,
  ),
  Event(
    id: '4',
    title: 'Exposición de Arte Moderno',
    imageUrl: 'https://picsum.photos/400/200?random=4',
    description:
        'Una colección impresionante de obras de arte moderno de artistas emergentes y consagrados. Incluye pintura, escultura e instalaciones interactivas.',
    date: DateTime(2023, 8, 5),
    time: '11:00 - 19:00 hrs',
    location: 'Museo de Arte Contemporáneo',
    totalCapacity: 300,
  ),
  Event(
    id: '5',
    title: 'Maratón Ciudad',
    imageUrl: 'https://picsum.photos/400/200?random=5',
    description:
        'Participa en la maratón anual de la ciudad con recorridos de 5k, 10k y 21k. Premios para los primeros lugares en cada categoría.',
    date: DateTime(2023, 9, 12),
    time: '07:00 - 12:00 hrs',
    location: 'Parque Central',
    totalCapacity: 1500,
  ),
];
