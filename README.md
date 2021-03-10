# PMNetworking

Чтобы вставить эту библиотеку (подключить эту зависимость) себе в Swift проект, воспользуйтесь Swift Package Manager, передав ссылку на этот репозиторий.


Чтобы переопределить то, как обрабатываются ответы сервера (имею в виду числа 200 , 404, вы поняли) надо передать замыкание с вашей логикой в последний параметр инициализатора объекта Resource. 
НАПРИМЕР:
``` swift
let resourse = Resource(url: url, requestMethod: .DELETE, headers: headers, decodingType: Todo.self) { status in
    switch status {
    case 200:
        fatalError("Hi")
    default:
        return
    }
}
```
Здесь передана эта логика через trailing closure. 
Во всем остальном самому легко разобраться.
