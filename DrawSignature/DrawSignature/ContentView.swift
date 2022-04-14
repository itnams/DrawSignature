//
//  ContentView.swift
//  DrawSignature
//
//  Created by ERM on 14/04/2022.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    var body: some View {
        Home()
    }
}


struct Home: View {
    @State var canvas: PKCanvasView = PKCanvasView()
    @State var isDraw: Bool = true
    @State var color: Color = .black
    @State var type: PKInkingTool.InkType = .pencil
    var body: some View{
        NavigationView{
            DrawingView(canvas: $canvas, isDraw: $isDraw, type: $type)
                .navigationTitle("Drawing")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: Button(action: {
                    saveImage()
                }, label: {
                    Image(systemName: "square.and.arrow.down.fill")
                        .font(.title)
                }),trailing: HStack(spacing: 20){
                    Button {
                        isDraw = false
                    } label: {
                        Image(systemName: "pencil.slash")
                            .font(.title)
                    }
                    Menu {
                        Button {
                            isDraw = true
                            type = .pencil
                        } label: {
                            Label {
                                Text("Pencil")
                            } icon: {
                                Image(systemName: "pencil")
                            }
                            
                        }
                        Button {
                            isDraw = true
                            type = .pen
                        } label: {
                            Label {
                                Text("Pen")
                            } icon: {
                                Image(systemName: "pencil.tip")
                            }
                            
                        }
                        Button {
                            isDraw = true
                            type = .marker
                        } label: {
                            Label {
                                Text("Marker")
                            } icon: {
                                Image(systemName: "highlighter")
                            }
                            
                        }
                    } label: {
                        Image(systemName: "list.dash")
                            .resizable()
                            .frame(width: 22, height: 22)
                    }
                })
        }
    }
    func saveImage(){
        let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
        let imagePNG = UIImage(data: image.pngData()!)!
        UIImageWriteToSavedPhotosAlbum(imagePNG, nil, nil, nil)
    }
}

struct DrawingView  : UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var isDraw: Bool
    @Binding var type: PKInkingTool.InkType
    var ink: PKInkingTool{
        PKInkingTool(type, color: .red)
    }
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView  {
        canvas.drawingPolicy = .anyInput
        canvas.tool = isDraw ? ink : eraser
        return canvas
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.tool = isDraw ? ink : eraser
    }
}
