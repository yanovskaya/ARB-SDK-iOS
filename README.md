# ARB SDK
ARB SDK - библиотека для открытия 3D-моделей в AR и VR.

## Быстрая интеграция:
1. Скачать `ARB.framework` по [ссылке](https://drive.google.com/file/d/1jW9ATlEhttmueL4suWjYxcllH-JUawch/view?usp=sharing).

2. Добавить в проект (Embedded binaries & Linked frameworks and libraries) 

3. Перед переходом на экран с AR добавить код:

```swift
import SceneKit
import ARB
```

```swift
guard let modelURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-b1aa7.appspot.com/o/model%20(3).scn?alt=media&token=9bf4cf2f-a84b-40ca-9214-409917b7d7b7"),
    let modelScene = try? SCNScene(url: modelURL) else { return }

guard let textureURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-b1aa7.appspot.com/o/diffuse.jpg?alt=media&token=c3b7a75e-1055-4b0e-9183-16e657d5dd54"),
    let textureData = try? Data(contentsOf: textureURL),
    let texture = UIImage(data: textureData) else { return }

let modelObjects = ModelObjects(model: modelScene, diffuse: texture)
let router = ARBRouter(sender: self, modelObjects: modelObjects)
router.showAR()
```
 
1. Если устройство не поддерживает ARKit - откроется экран без камеры (VR). 
2. Если устройство поддерживает ARKit - откроется камера, которую нужно навести на поверхность и поставить модель.

**Доступные действия:** крутить и увеличивать модель.

## Кастомизация экранов:
1. Для устройств, не поддерживающих ARKit:

```swift
import SceneKit
import ARB

class CustomScnViewController: ARBScnViewController {
    
    @IBOutlet var sceneView: SCNView!
    
    override func viewDidLoad() {
        arbSceneView = sceneView
        super.viewDidLoad()
        // your code
    }
}
```
Перед переходом на AR указать:
```
router.customScnViewController = CustomScnViewController()
```
Либо другим способом указать CustomScnViewController.

2. Для устройств, поддерживающих ARKit:

```swift
import ARKit
import ARB

class CustomViewController: ARBViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        arbSceneView = sceneView
        super.viewDidLoad()
        // your code
    }
}
```
Перед переходом на AR указать:
```
router.customScnViewController = CustomScnViewController()
```
Либо другим способом указать CustomScnViewController.


## Пример интеграции
В примере `StartViewController` парсит JSON с URL для картинки и модели. Далее скаичвается картинка. 

**При возникновении вопросов:<br/>
tg @elenayanovskaya**