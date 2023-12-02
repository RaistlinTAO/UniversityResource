#include <CanvasPoint.h>
#include <CanvasTriangle.h>
#include <DrawingWindow.h>
#include <Utils.h>
#include <fstream>
#include <vector>
#include <Colour.h>
#include <glm/glm.hpp>
#include <sstream>
#include <unordered_map>
#include "TextureMap.h"
#include "ModelTriangle.h"

#define WIDTH 320
#define HEIGHT 240
#define SCALING_FACTOR 0.35
#define IMAGE_PLANE_SCALE 240

void draw(DrawingWindow &window) {
    window.clearPixels();
    for (size_t y = 0; y < window.height; y++) {
        for (size_t x = 0; x < window.width; x++) {
            float red = rand() % 256;
            float green = 0.0;
            float blue = 0.0;
            uint32_t colour = (255 << 24) + (int(red) << 16) + (int(green) << 8) + int(blue);
            window.setPixelColour(x, y, colour);
        }
    }
}

void handleEvent(SDL_Event event, DrawingWindow &window) {
    if (event.type == SDL_KEYDOWN) {
        if (event.key.keysym.sym == SDLK_LEFT) std::cout << "LEFT" << std::endl;
        else if (event.key.keysym.sym == SDLK_RIGHT) std::cout << "RIGHT" << std::endl;
        else if (event.key.keysym.sym == SDLK_UP) std::cout << "UP" << std::endl;
        else if (event.key.keysym.sym == SDLK_DOWN) std::cout << "DOWN" << std::endl;
    } else if (event.type == SDL_MOUSEBUTTONDOWN) {
        window.savePPM("output.ppm");
        window.saveBMP("output.bmp");

    }
}

//region WEEK 2

/**
 * Week 2 Task 2: Single Element Numerical Interpolation
 * @param from  start point
 * @param to    end point
 * @param numberOfValues Steps
 * @return
 */
std::vector<float> interpolateSingleFloats(float from, float to, int numberOfValues) {
    std::vector<float> interpolatedValues;
    float seed = (to - from) / (numberOfValues - 1);

    for (int i = 0; i < numberOfValues; i++) {
        float value = from + i * seed;
        interpolatedValues.push_back(value);
    }

    return interpolatedValues;
}

/**
 * Week 2 Task 4: Three Element Numerical Interpolation
 * @param from
 * @param to
 * @param numberOfValues
 * @return
 */
std::vector<glm::vec3> interpolateThreeElementValues(glm::vec3 from, glm::vec3 to, int numberOfValues) {
    std::vector<glm::vec3> interpolatedValues;

    float seed = (to[0] - from[0]) / (numberOfValues - 1);
    float seed1 = (to[1] - from[1]) / (numberOfValues - 1);
    float seed2 = (to[2] - from[2]) / (numberOfValues - 1);

    for (int i = 0; i < numberOfValues; i++) {
        float value0 = from[0] + i * seed;
        float value1 = from[1] + i * seed1;
        float value2 = from[2] + i * seed2;
        interpolatedValues.push_back(glm::vec3(value0, value1, value2));
    }

    return interpolatedValues;
}

/**
 * Week 2 Task 3: Single Dimension Greyscale Interpolation
 * @param window
 */
void drawGrey(DrawingWindow &window) {
    window.clearPixels();
    std::vector<float> list = interpolateSingleFloats(255, 0, window.width);
    for (int x = 0; x < (int) window.width; x++) {
        for (int y = 0; y < (int) window.height; ++y) {
            uint32_t colour = (255 << 34) + (int(list[x]) << 16) + (int(list[x]) << 8) + int(list[x]);
            window.setPixelColour(x, y, colour);
        }
    }
}

/**
 * Week 2 Task 5: Two Dimensional Colour Interpolation
 * @param window
 */
void drawColourful(DrawingWindow &window) {
    window.clearPixels();
    glm::vec3 topLeft(255, 0, 0);        // red
    glm::vec3 topRight(0, 0, 255);       // blue
    glm::vec3 bottomRight(0, 255, 0);    // green
    glm::vec3 bottomLeft(255, 255, 0);   // yellow
    std::vector<glm::vec3> listLeftTopToBottom = interpolateThreeElementValues(topLeft, bottomLeft, window.height);
    std::vector<glm::vec3> listRightTopToBottom = interpolateThreeElementValues(topRight, bottomRight, window.height);
    for (int y = 0; y < (int) window.height; y++) {
        std::vector<glm::vec3> listXColour = interpolateThreeElementValues(listLeftTopToBottom[y],
                                                                           listRightTopToBottom[y], window.width);
        for (size_t x = 0; x < window.width; x++) {
            uint32_t colour = (255 << 34) + (int(listXColour[x][0]) << 16) + (int(listXColour[x][1]) << 8) +
                              int(listXColour[x][2]);
            window.setPixelColour(x, y, colour);
        }
    }
}

//endregion

//region WEEK 3

/**
 * Week 3 Task 2: Line Drawing
 * @param window
 */
void drawLine(DrawingWindow &window, CanvasPoint from, CanvasPoint to, const Colour &colour) {
// Calculate the differences in x and y
    float dx = to.x - from.x;
    float dy = to.y - from.y;

    // Calculate steps required for generating pixels
    int steps = abs(dx) > abs(dy) ? abs(dx) : abs(dy);

    // Calculate increments in x and y
    float xi = dx / float(steps);
    float yi = dy / float(steps);

    float x = from.x;
    float y = from.y;

    uint32_t color = (255 << 24) + (int(colour.red) << 16) + (int(colour.green) << 8) +
                     int(colour.blue); // Create a uint32_t ARGB color

    for (int i = 0; i <= steps; i++) {
        window.setPixelColour(round(x), round(y), color); // Set the pixel color at rounded (x, y)
        x += xi;
        y += yi;
    }
}

/**
 * Week 3 Task 3: Stroked Triangles
 * @param window
 * @param triangle
 * @param colour
 */
void drawTriangle(DrawingWindow &window, CanvasTriangle triangle, const Colour &colour) {
    drawLine(window, triangle.vertices[0], triangle.vertices[1], colour);
    drawLine(window, triangle.vertices[1], triangle.vertices[2], colour);
    drawLine(window, triangle.vertices[2], triangle.vertices[0], colour);
}

void sortVertices(CanvasPoint &p1, CanvasPoint &p2, CanvasPoint &p3) {
    if (p1.y > p2.y) std::swap(p1, p2);
    if (p1.y > p3.y) std::swap(p1, p3);
    if (p2.y > p3.y) std::swap(p2, p3);
}

/// getTrianglePointPair
/// \param p1
/// \param p2
/// \param p3
/// \param y
/// \return Start Point / End Point of pair
std::vector<CanvasPoint> getTrianglePointPair(CanvasPoint &p1, CanvasPoint &p2, CanvasPoint &p3, float y) {
    //Assume that p1.y is top point and p3 is bottom point (p1.y is min, and p3.y is max)
    // 2 Types of Triangle:
    //      1. P2 on the left side of P1
    //      2. P2 on the right side of P1
    CanvasPoint leftPoint;
    CanvasPoint rightPoint;
    std::vector<CanvasPoint> pointPair;
    if (p2.x < p1.x) {
        //P2 on the left side of P1
        rightPoint.x = p1.x + (p3.x - p1.x) / (p3.y - p1.y) * (y - p1.y);
        rightPoint.y = y;
        if (y <= p2.y) {
            leftPoint.x = p1.x - (p1.x - p2.x) / (p2.y - p1.y) * (y - p1.y);
            leftPoint.y = y;
        } else {
            leftPoint.x = p2.x + (p3.x - p2.x) / (p3.y - p2.y) * (y - p2.y);
            leftPoint.y = y;
        }
    } else {
        //P2 on the right side of P1
        leftPoint.x = p1.x - (p1.x - p3.x) / (p3.y - p1.y) * (y - p1.y);
        leftPoint.y = y;
        if (y <= p2.y) {
            rightPoint.x = p1.x + (p2.x - p1.x) / (p2.y - p1.y) * (y - p1.y);
            rightPoint.y = y;
        } else {
            rightPoint.x = p3.x + (p2.x - p3.x) / (p3.y - p2.y) * (y - p2.y);
            rightPoint.y = y;
        }
    }
    pointPair.push_back(leftPoint);
    pointPair.push_back(rightPoint);
    return pointPair;
}

std::vector<CanvasPoint>
getTrianglePointPairV2(const CanvasPoint &p1, const CanvasPoint &p2, const CanvasPoint &p3, float y) {
    std::vector<CanvasPoint> pointPair;

    // Calculate the slopes
    float slope1 = (p2.y - p1.y) > 0 ? (p2.x - p1.x) / (p2.y - p1.y) : 0;
    float slope2 = (p3.y - p1.y) > 0 ? (p3.x - p1.x) / (p3.y - p1.y) : 0;
    float slope3 = (p3.y - p2.y) > 0 ? (p3.x - p2.x) / (p3.y - p2.y) : 0;

    // Calculate the x-coordinates of the intersection points
    float xLeft = p1.x + (y - p1.y) * slope2;
    float xRight = p1.x + (y - p1.y) * slope1;

    if (y > p2.y) {
        xLeft = p2.x + (y - p2.y) * slope3;
        xRight = p3.x + (y - p3.y) * slope2;
    }

    CanvasPoint leftPoint = {xLeft, y};
    CanvasPoint rightPoint = {xRight, y};

    pointPair.push_back(leftPoint);
    pointPair.push_back(rightPoint);

    return pointPair;
}

/// getTrianglePointPairV3
/// \param p1x
/// \param p1y
/// \param p2x
/// \param p2y
/// \param p3x
/// \param p3y
/// \param y
/// \return Start Point (x , y) / End Point (x , y) of pair
std::vector<std::vector<float>>
getTrianglePointPairV3(float p1x, float p1y, float p2x, float p2y, float p3x, float p3y, float y) {
    //Assume that p1y is top point and p3 is bottom point (p1y is min, and p3y is max)
    // 2 Types of Triangle:
    //      1. P2 on the left side of P1
    //      2. P2 on the right side of P1
    std::vector<float> leftPoint;
    std::vector<float> rightPoint;
    std::vector<std::vector<float>> pointPair;
    if (p2x < p1x) {
        //P2 on the left side of P1
        rightPoint.push_back(p1x + (p3x - p1x) / (p3y - p1y) * (y - p1y));
        rightPoint.push_back(y);
        if (y <= p2y) {
            leftPoint.push_back(p1x - (p1x - p2x) / (p2y - p1y) * (y - p1y));
            leftPoint.push_back(y);
        } else {
            leftPoint.push_back(p2x + (p3x - p2x) / (p3y - p2y) * (y - p2y));
            leftPoint.push_back(y);
        }
    } else {
        //P2 on the right side of P1
        leftPoint.push_back(p1x - (p1x - p3x) / (p3y - p1y) * (y - p1y));
        leftPoint.push_back(y);
        if (y <= p2y) {
            rightPoint.push_back(p1x + (p2x - p1x) / (p2y - p1y) * (y - p1y));
            rightPoint.push_back(y);
        } else {
            rightPoint.push_back(p3x + (p2x - p3x) / (p3y - p2y) * (y - p2y));
            rightPoint.push_back(y);
        }
    }
    pointPair.push_back(leftPoint);
    pointPair.push_back(rightPoint);
    return pointPair;
}

/**
 * Week 3 Task 4: Filled Triangles
 * @param window
 * @param triangle
 * @param fillColour
 */
void drawFilledTriangle(DrawingWindow &window, CanvasTriangle triangle, const Colour &fillColour) {
    // Sort the vertices by y-coordinate

    CanvasPoint p1 = triangle.vertices[0];
    CanvasPoint p2 = triangle.vertices[1];
    CanvasPoint p3 = triangle.vertices[2];

    sortVertices(p1, p2, p3);

    uint32_t color = (255 << 24) + (int(fillColour.red) << 16) + (int(fillColour.green) << 8) + int(fillColour.blue);
    //P1 will be top Point, p2 middle and P3 bottom
    //Hence P2.y is middle right
    for (int currentY = (int) p1.y; currentY < (int) p3.y; ++currentY) {
        //std::vector<CanvasPoint> pair = getTrianglePointPair(p1, p2, p3, currentY);
        //drawLine(window, pair[0], pair[1], fillColour);
        std::vector<std::vector<float>> pair = getTrianglePointPairV3(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, currentY);
        for (int i = pair[0][0]; i < pair[1][0]; ++i) {
            window.setPixelColour(round(i), round(currentY), color);
        }
    }
}

// Week 3
TexturePoint mapToTexture(CanvasPoint target, int canvasWidth, int canvasHeight, int textureWidth, int textureHeight) {
    int tx = (target.x * textureWidth) / canvasWidth;
    int ty = (target.y * textureHeight) / canvasHeight;
    return TexturePoint(tx, ty);
}

/**
 * Week 3 Task 5: drawTexture
 * @param window
 * @param triangle
 * @param t1
 * @param t2
 * @param t3
 * @param _texture
 */
void
drawTextureTriangle(DrawingWindow &window, CanvasTriangle triangle, const TextureMap &_texture) {
    CanvasPoint p1 = triangle.vertices[0];
    CanvasPoint p2 = triangle.vertices[1];
    CanvasPoint p3 = triangle.vertices[2];

    sortVertices(p1, p2, p3);
    //sortTexturePoints(t1, t2, t3);

    //The rows number is _texture.height
    //and each row contains _texture.width pixels
    //The color of specific (x, y) in _texture
    std::vector<std::vector<uint32_t>> colourArray;
    for (int y = 0; y < _texture.height; ++y) {
        std::vector<uint32_t> rowColours(_texture.pixels.begin() + _texture.width * y,
                                         _texture.pixels.begin() + _texture.width * (y + 1));
        colourArray.push_back(rowColours);
    }

    for (int currentY = (int) p1.y; currentY < (int) p3.y; ++currentY) {
        std::vector<std::vector<float>> pair = getTrianglePointPairV3(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, currentY);
        //std::vector<std::vector<float>> pair2 = getTrianglePointPairV3(t1.x, t1.y, t2.x, t2.y, t3.x, t3.y, currentY);
        for (int i = pair[0][0]; i < pair[1][0]; ++i) {
            // target y / source y = target full height / source full height, solving source y = target y * source full height / target full height, unless divide by zero
            // int currentSourceY = (int) (currentY * _texture.height / window.height);
            //target x / source x = target full width / source full width, solving source x = target x * source full width / target full width, unless divide by zero
//            float currentSourceX = 0;
//            if (round(pair[1][0]) - round(pair[0][0]) != 0) {
//                currentSourceX = (int) (i * _texture.width / window.width);
//            } else {
//                currentSourceX = round(p1.texturePoint.x);
//            }
            TexturePoint mapTexturePoint = mapToTexture(CanvasPoint(i, currentY), window.width, window.height,
                                                        _texture.width, _texture.height);
            window.setPixelColour(round(i), round(currentY), colourArray[mapTexturePoint.y][mapTexturePoint.x]);
        }

    }

}

//endregion

//region WEEK 4

/**
 * Week 4 Task 2: Geometry Files
 * @param fileName
 * @param points
 * @param triangles
 */
void modelProcessor(const std::string &fileName, std::vector<glm::vec3> &points,
                    std::vector<ModelTriangle> &triangles, std::unordered_map<std::string, Colour> colours) {
    std::ifstream file(fileName);
    std::string line;
    //std::vector<glm::vec3> points;
    //std::vector<std::array<int, 3>> faceIndex;
    std::vector<ModelTriangle> modelTriangles;
    std::string currentColourName;
    Colour currentColour;
    while (std::getline(file, line)) {
        ModelTriangle tempTriangle;
        if (line.empty()) {
            continue;
        }

        std::istringstream lineStream(line);
        std::string token;
        lineStream >> token;
        if (token == "o") {
            //Object Name
        }

        if (token == "v") {
            //Processing V
            //v 1.480989 -1.088751 2.155087
            std::vector<std::string> tempValue = split(line, ' ');

            //Add a scaling factor (float) parameter to your OBJ loading function that scales the position of all vertices at the point at which they are read in from the file
            glm::vec3 point(std::stof(tempValue[1]) * SCALING_FACTOR, std::stof(tempValue[2]) * SCALING_FACTOR,
                            std::stof(tempValue[3]) * SCALING_FACTOR);
            points.push_back(point);

        }
        if(token == "vt")
        {
        }
        if (token == "f") {
            //Processing f
            //f 25/ 27/ 28/

            std::vector<std::string> tempValue = split(line, ' ');

f 5/6 7/8 9/10
            tempValue[1].split('/')[0] 5
            tempValue[2].split('/')[0] 7
             tempValue[3].split('/')[0] 9

             tempValue[1].split('/')[1] 6
            tempValue[2].split('/')[1] 8
            tempValue[3].split('/')[1] 10



            //Remember that vertices in OBJ files are indexed from 1 (whereas vectors are indexed from 0). so just mines 1
//            faceIndex.push_back(
//                    {std::stoi(tempValue[1]) - 1, std::stoi(tempValue[2]) - 1, std::stoi(tempValue[3]) - 1});
            triangles.emplace_back(points[stoi(tempValue[1]) - 1], points[std::stoi(tempValue[2]) - 1],
                                   points[std::stoi(tempValue[3]) - 1], currentColour);
        }

    }
}

/**
 * Week 4 Task 3: Material Files
 * @param fileName
 * @return
 */
std::unordered_map<std::string, Colour> materialProcessor(const std::string &fileName) {
    std::ifstream file(fileName);
    std::string line;
    std::unordered_map<std::string, Colour> colours;
    Colour currentColour;
    while (std::getline(file, line)) {
        if (line.empty()) {
            continue;
        }
        std::istringstream lineStream(line);
        std::string token;
        lineStream >> token;
        if (token == "newmtl") {
            currentColour = Colour();
            lineStream >> currentColour.name;
        } else if (token == "Kd") {
            // MTL colour channel value
            float r, g, b;
            lineStream >> r >> g >> b;
            currentColour.red = static_cast<int>(r * 255);
            currentColour.green = static_cast<int>(g * 255);
            currentColour.blue = static_cast<int>(b * 255);
            colours[currentColour.name] = currentColour;
        }
    }
    return colours;
}

/**
 * Week 4 Task 5: Projection in Practice
 * @param cameraPosition
 * @param vertexPosition
 * @param focalLength
 * @return
 */
glm::vec2 getCanvasIntersectionPoint(glm::vec3 cameraPosition, glm::vec3 vertexPosition, float focalLength) {
    glm::vec3 relativePosition = vertexPosition - cameraPosition;

    float ui = ((focalLength + IMAGE_PLANE_SCALE / 2) * relativePosition.x) / relativePosition.z + (WIDTH / 2);
    float vi = ((focalLength + IMAGE_PLANE_SCALE / 2) * relativePosition.y) / relativePosition.z + (HEIGHT / 2);

    //This Line must exist, otherwise the image will left side - right
    ui = WIDTH - ui;

    return glm::vec2(ui, vi);
}

//endregion


int main(int argc, char *argv[]) {
    //getFile("cornell-box.obj");

    DrawingWindow window = DrawingWindow(WIDTH, HEIGHT, false);
    SDL_Event event;

//    std::vector<float> result;
//    result = interpolateSingleFloats(2.2, 8.5, 7);
//    for (size_t i = 0; i < result.size(); i++) std::cout << result[i] << " ";
//    std::cout << std::endl;
//
//    std::vector<glm::vec3> result3;
//    result3 = interpolateThreeElementValues(glm::vec3(1.0, 4.0, 9.2), glm::vec3(4.0, 1.0, 9.8), 4);
//    for (size_t i = 0; i < result3.size(); i++)
//        std::cout << result3[i][0] << ',' << result3[i][1] << ',' << result3[i][2] << " ";
//    std::cout << std::endl;

    std::vector<glm::vec3> points;
    std::vector<ModelTriangle> triangles;
    std::unordered_map<std::string, Colour> colours = materialProcessor("/home/v2raydev/RedNoise/src/cornell-box.mtl");
    modelProcessor("/home/v2raydev/RedNoise/src/cornell-box.obj", points, triangles, colours);

    glm::vec3 cameraPosition(0.0, 0.0, 4.0);
    float focalLength = 240;


    //std::cout << content << " ";
    while (true) {
        // We MUST poll for events - otherwise the window will freeze !
        if (window.pollForInputEvents(event)) handleEvent(event, window);
        for (const ModelTriangle &triangle: triangles) {
            std::cout << triangle << " ColourL " << triangle.colour << std::endl;
            std::cout << "Postion: " << getCanvasIntersectionPoint(cameraPosition, triangle.vertices[0], focalLength)[0]
                      << ", " << getCanvasIntersectionPoint(cameraPosition, triangle.vertices[0], focalLength)[1]
                      << std::endl;
            glm::vec2 p1 = getCanvasIntersectionPoint(cameraPosition, triangle.vertices[0], focalLength);
            glm::vec2 p2 = getCanvasIntersectionPoint(cameraPosition, triangle.vertices[1], focalLength);
            glm::vec2 p3 = getCanvasIntersectionPoint(cameraPosition, triangle.vertices[2], focalLength);
            uint32_t color = (255 << 24) + (int(triangle.colour.red) << 16) + (int(triangle.colour.green) << 8) +
                             int(triangle.colour.blue);
            window.setPixelColour(p1.x, p1.y, (255 << 24) + (255 << 16) +
                                              (255 << 8) + int(255));
            window.setPixelColour(p2.x, p2.y, (255 << 24) + (255 << 16) +
                                              (255 << 8) + int(255));
            window.setPixelColour(p3.x, p3.y, (255 << 24) + (255 << 16) +
                                              (255 << 8) + int(255));
//            CanvasPoint p1(getCanvasIntersectionPoint(cameraPosition, triangle.vertices[0], focalLength)[0],
//                           getCanvasIntersectionPoint(cameraPosition, triangle.vertices[0], focalLength)[1]);
//            CanvasPoint p2(getCanvasIntersectionPoint(cameraPosition, triangle.vertices[1], focalLength)[0],
//                           getCanvasIntersectionPoint(cameraPosition, triangle.vertices[1], focalLength)[1]);
//            CanvasPoint p3(getCanvasIntersectionPoint(cameraPosition, triangle.vertices[2], focalLength)[0],
//                           getCanvasIntersectionPoint(cameraPosition, triangle.vertices[2], focalLength)[1]);
//            CanvasTriangle tempT(p1, p2, p3);
//
//            drawTriangle(window, tempT, triangle.colour);
        }
        /*
         * Draw Lines
         */
//        CanvasPoint topLeft(0, 0);
//        CanvasPoint center(WIDTH / 2, HEIGHT / 2);
//        Colour red(255, 0, 0);
//        drawLine(window, topLeft, center, red);

//        CanvasPoint p1(rand() % WIDTH, rand() % HEIGHT);
//        CanvasPoint p2(rand() % WIDTH, rand() % HEIGHT);
//        CanvasPoint p3(rand() % WIDTH, rand() % HEIGHT);

        /*
         * Draw Triangle
         */
//        CanvasTriangle triangle(p1, p2, p3);
//        Colour colour(rand() % 256, rand() % 256, rand() % 256);
//        drawTriangle(window, triangle, colour);

        /*
         * Draw Filled Triangle
         */
//        CanvasPoint p1(160, 10);
//        CanvasPoint p2(300, 230);
//        CanvasPoint p3(10, 150);
//        CanvasTriangle triangle(p1, p2, p3);
//        Colour colour(rand() % 256, rand() % 256, rand() % 256);
//        Colour whiteBorder(255, 255, 255);
//        Colour red(255, 0, 0);
//        drawFilledTriangle(window, triangle, red);
//        drawTriangle(window, triangle, whiteBorder);

//        CanvasPoint p1(160, 10);
//        CanvasPoint p2(300, 230);
//        CanvasPoint p3(10, 150);
//        TexturePoint t1(195, 5);
//        TexturePoint t2(395, 380);
//        TexturePoint t3(65, 330);
//        p1.texturePoint = t1;
//        p2.texturePoint = t2;
//        p3.texturePoint = t3;
//        CanvasTriangle triangle(p1, p2, p3);
//        //Check texture source
//        TextureMap _source = TextureMap("/home/v2raydev/RedNoise/src/texture.ppm");
//        //std::cout << "_source.width: " << _source.width << ", _source.height: " << _source.height << " ";
//        //std::cout << "_source.pixel: " << _source.pixels[0];
//
//        // Height 395 Width 480
//        // RGB Packed colour: 4289305750 4294901760
//        drawTextureTriangle(window, triangle, _source);


        // Need to render the frame at the end, or nothing actually gets shown on the screen !
        window.renderFrame();
    }
}
