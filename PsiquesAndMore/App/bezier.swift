import SwiftUI
import Foundation
import UIKit


// 1: Criar uma extensão do BezierPath para armazenar os ícones
extension UIBezierPath {
    static var lateralArrow: UIBezierPath {
        let path = UIBezierPath()

        path.move(to: CGPoint(x: 18, y: 36))
        path.addLine(to: CGPoint(x: 0, y: 18))
        path.addLine(to: CGPoint(x: 18, y: 0))
        path.addLine(to: CGPoint(x: 23.04, y: 5.04))
        path.addLine(to: CGPoint(x: 13.77, y: 14.4))
        path.addLine(to: CGPoint(x: 58.23, y: 0))
        path.addLine(to: CGPoint(x: 48.96, y: 5.04))
        path.addLine(to: CGPoint(x: 54, y: 0))
        path.addLine(to: CGPoint(x: 72, y: 18))
        path.addLine(to: CGPoint(x: 54, y: 36))
        path.addLine(to: CGPoint(x: 48.96, y: 30.96))
        path.addLine(to: CGPoint(x: 58.23, y: 21.6))
        path.addLine(to: CGPoint(x: 13.77, y: 0))
        path.addLine(to: CGPoint(x: 23.04, y: 30.96))
        path.addLine(to: CGPoint(x: 18, y: 36))

        // O código original não tinha o close, mas deixei aqui pq acho que pode ser necessário
        path.close()

        return path
    }
}

// 2: Criar função que vai ser responsável por trazer o ícone no tamanho certo
struct ScaledBezier: Shape {
    let bezierPath: UIBezierPath

    func path(in rect: CGRect) -> Path {
        let path = Path(bezierPath.cgPath)

        // Aqui vai ser calculado qual o fator de multiplicação que será utilizado para fazer o ícone caber no espaço disponível
        let multiplier = min(rect.width, rect.height)

        // AffineTransform: responsável por redimensionar igualmente na mesma proporção
        let transform = CGAffineTransform(scaleX: multiplier, y: multiplier)

        // Aplica a escala e retorna o resultado da transformação
        return path.applying(transform)
    }
}

// Como mostrar o ícone em uma View:
struct ContentView: View {
    var body: some View {
        // Aqui passa o nome do ícone
        ScaledBezier(bezierPath: .lateralArrow)
            // Esse stroke aqui eu não sei se precisa, mas o código original tava usando
            .stroke(lineWidth: 2)
            .fill()
            // Aqui precisa passar a largura e a altura máxima do ícone. É o tamanho que ele precisa ter para aparecer onde tu quer que ele apareça
            .frame(width: 200, height: 200)
    }
}
