public class GraphPoint {
    java.lang.Integer cValue;
    java.lang.Integer pValue;
    java.lang.Integer nValue;

    PVector controlPointAngle;
    float controlPointStrengthPrevious;
    float controlPointStrengthNext;

    public PVector controlPointPrev;
    public PVector controlPointNext;

    public GraphPoint(java.lang.Integer value, java.lang.Integer previousValue, java.lang.Integer nextValue) {
        cValue = value;
        pValue = previousValue;
        nValue = nextValue;

        // Initialise control points
        controlPointAngle = new PVector(1, 0);
        controlPointStrengthPrevious = controlPointAngle.mag();
        controlPointStrengthNext = controlPointAngle.mag();

        controlPointPrev = new PVector();
        controlPointNext = new PVector();
    }

    public int CurrentGraphValue() {
        return cValue;
    }

    public void UpdateGraphValue(int newValue) {
        cValue = newValue;
    }

    public void Render(int xLocation) {
        CalculateControlPointValues();
        CalculateControlPoints(xLocation);
        RenderControlPoints(xLocation);

        stroke(255, 255, 0);
        strokeWeight(10);
        point(xLocation, cValue);
    }

    private void CalculateControlPointValues() {
        // Special conditions for first and last
        if (pValue == null) {
            controlPointAngle.x = 1;
            controlPointAngle.y = -1;
        } 
        else if (nValue == null) {
            controlPointAngle.x = 1;
            controlPointAngle.y = 1;
        } 
        else {
            boolean isPreviousLower = pValue < cValue;
            boolean isNextLower = nValue < cValue;

            if ((isPreviousLower && isNextLower) || (!isPreviousLower && !isNextLower)) { // Might need to also say "if previous or next are equal, consider it the same". Test first
                controlPointAngle.x = 1;
                controlPointAngle.y = 0;
                CalculateNewControlAngles();
            } 
            else {
                controlPointAngle.x = 1;
                controlPointAngle.y = 1;
                CalculateNewControlAngles();
            }
        }
        CalculateNewControlAngles();
        // Get the magnitute. 
        controlPointStrengthPrevious = controlPointAngle.mag();
        controlPointStrengthNext = controlPointAngle.mag();
    }

    private void CalculateNewControlAngles() {
        // TEMP
        println("test");
        stroke(200);
        strokeWeight(1);
        line(controlPointPrev.x, -controlPointPrev.y, controlPointNext.x, -controlPointNext.y);
    }

    private void CalculateControlPoints(int xLocation) {
        // From known angle of vector, do some trigonometry to get new x, and y
        float hLength = controlPointStrengthNext * 30;
        float angleInDegrees = controlPointAngle.heading() * (180 / PI);
        float xAcross = cos(angleInDegrees) * hLength;
        float yDown = sqrt(sq(hLength) - sq(xAcross));

        // If the angle is negative then we need to reverse the "up and down" logic
        if (angleInDegrees < 0) {
            controlPointPrev.x = xLocation - xAcross;
            controlPointPrev.y = cValue + yDown;

            controlPointNext.x = xLocation + xAcross;
            controlPointNext.y = cValue - yDown;
        } 
        else {
            controlPointPrev.x = xLocation - xAcross;
            controlPointPrev.y = cValue - yDown;

            controlPointNext.x = xLocation + xAcross;
            controlPointNext.y = cValue + yDown;
        }
    }

    private void RenderControlPoints(int xLocation) {
        // Next control point
        strokeWeight(8);
        stroke(255, 0, 0);
        point(controlPointNext.x, controlPointNext.y);

        // Previous control point
        stroke(0, 255, 0);
        point(controlPointPrev.x, controlPointPrev.y);

        // Lines between points
        stroke(255, 100);
        strokeWeight(1);
        line(xLocation, cValue, controlPointNext.x, controlPointNext.y);
        line(xLocation, cValue, controlPointPrev.x, controlPointPrev.y);
    }
}