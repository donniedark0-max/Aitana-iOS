# Aitana for iOS

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5-blue.svg)
![iOS](https://img.shields.io/badge/iOS-17.0+-lightgrey.svg)
![Xcode](https://img.shields.io/badge/Xcode-15+-blue.svg)

**Aitana for iOS** es el cliente nativo para AITANA 2.0, un asistente de visión en tiempo real impulsado por IA. Esta aplicación está diseñada desde cero utilizando SwiftUI, aprovechando las últimas tecnologías de Apple para ofrecer una experiencia de usuario fluida, accesible y minimalista.

## Visión del Proyecto

El objetivo de AITANA es actuar como los ojos y oídos de sus usuarios, proporcionando descripciones contextuales del entorno, leyendo texto, reconociendo rostros y objetos, y manteniendo una conversación natural. La aplicación está diseñada pensando en:

-   **Personas con discapacidad visual**: Proporcionando independencia y una mayor comprensión de su entorno.
-   **Estudiantes y profesionales**: Ofreciendo una forma rápida de digitalizar texto o analizar escenas.
-   **Cualquier persona**: Que necesite un asistente inteligente para interactuar con el mundo físico a través de la IA.

## Arquitectura y Tecnología

La aplicación se construye sobre una base moderna y escalable, siguiendo las mejores prácticas de desarrollo para iOS.

### Principios Arquitectónicos

-   **MVVM (Model-View-ViewModel)**: Separa la lógica de la interfaz de usuario, facilitando las pruebas y la mantenibilidad.
-   **SwiftUI Nativo**: Toda la interfaz de usuario se construye de forma declarativa con SwiftUI, garantizando un rendimiento óptimo y una integración profunda con el ecosistema de Apple.
-   **Programación Asíncrona (`async/await`)**: Todas las operaciones de red y tareas pesadas se manejan de forma asíncrona para mantener la interfaz de usuario siempre receptiva.
-   **Inyección de Dependencias**: Los servicios (red, cámara, etc.) se diseñan para ser inyectados, lo que permite una fácil sustitución y pruebas unitarias.

### Componentes Clave

-   **Capa de Red**:
    -   **`URLSession`**: Para todas las llamadas transaccionales HTTP (REST) al `api-orchestrator`.
    -   **`URLSessionWebSocketTask`**: Para la comunicación bidireccional y de baja latencia de los streams de audio y video.
-   **Servicios de Hardware**:
    -   **`AVFoundation`**: Para el acceso y control total sobre la captura de video de la cámara.
    -   **`AVAudioEngine`**: Para la captura en tiempo real del audio del micrófono.
-   **Gestión de Datos**:
    -   **`Codable`**: Para la decodificación segura y automática de las respuestas JSON del backend en `structs` nativas de Swift.

## Flujo de Comunicación con el Backend

La aplicación se comunica exclusivamente con el `api-orchestrator`, que actúa como un único punto de entrada a la arquitectura de microservicios de AITANA 2.0.

1.  **Streaming de Visión**: La app captura fotogramas de la cámara, los codifica a JPEG y los envía a través de un WebSocket a `/api/vision/stream/detect`. Recibe un JSON con los objetos y gestos detectados en tiempo real.
2.  **Streaming de Audio**: La app captura fragmentos de audio del micrófono y los envía a través de un WebSocket a `/api/audio/stream`. Recibe el audio de respuesta de Gemini y lo reproduce.
3.  **Acciones Transaccionales**: Para operaciones como el registro facial, la app realiza una llamada `HTTP POST` a endpoints específicos como `/api/v1/faces/register/start`.

## Estado del Proyecto

Actualmente, el proyecto se encuentra en la **Fase 2: Arquitectura del Cliente iOS**.

-   [x] Estructura del proyecto definida.
-   [x] Diseño de la interfaz de usuario para Login y Onboarding implementado en SwiftUI.
-   [ ] Implementación de la capa de red (`APIService`, `WebSocketManager`).
-   [ ] Implementación de los servicios de hardware (`CameraService`, `MicrophoneService`).
-   [ ] Integración de la pantalla `LiveView` con los streams de audio y video.

## Cómo Empezar

1.  Clona este repositorio.
2.  Abre el archivo `Aitana-ios.xcodeproj` en Xcode 15 o superior.
3.  Asegúrate de tener una instancia del [backend de AITANA 2.0](https://github.com/tu-usuario/aitana-backend) corriendo localmente o en la red.
4.  Actualiza la URL base en la capa de red para que apunte a tu backend.
5.  Ejecuta la aplicación en un simulador o en un dispositivo físico con iOS 17.0 o superior.

---

<p align="center">
  <img src="https://64.media.tumblr.com/1e7d68af24ad1fdfcde03cc624c5134a/8cc48d4671c3d1d8-f4/s1280x1920/2e978c39a57bae098a2c5ecfbdf4b461ec89db69.jpg" alt="Aitana Concept Art" width="400"/>
</p>
