# Programación orientada a objetos

★ `bless` de Perl

★ Dijkstra vs Kay

## Conceptos fundamentales de POO

- Un objeto puede enviar un **mensaje** a otro, lo cual es una solicitud al objeto receptor para que lleve a cabo una de sus operaciones
- La **interfaz** de un objeto es el conjunto de mensajes que es capaz de responder
- Un **método** es la implementación efectiva de la operación solicitada por el mensaje
- La forma en la que un objeto lleva a cabo una operación puede depender de parámetros o argumentos del mensaje recibido (colaboradores externos) así como de su _estado interno_, dado por un conjunto de atribubtos o variables de instancia del objeto receptor (colaboradores internos)

### Consecuencia del encapsulamiento

- Si se cambia la representación de una entidad no se modifica el comportamiento del sistema. Una misma entidad puede representarse por ejemplo con una linked list o un ABB y funcionar de igual manera, el usuario nunca se va a enterar.
- Un objeto se puede intercambiar sin ningún problema siempre y cuando aquel por el que se cambia implemente la misma interfaz (_duck typing_).

### Características del entorno Smalltalk

| **Envío de mensajes** | **Objetos** | **Clasificación** | **Herencia** |
| - | - | - | - |
| **Sincrónico y con respuesta** (vs. asincrónico y sin respuesta) | **Mutables** (vs. inmutables) | (vs. prototipado) | **Simple** (vs. múltiple) |

### Clases e instancias

