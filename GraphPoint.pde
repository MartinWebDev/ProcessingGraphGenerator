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

        // Wire in fake values for control points for now
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
        CalculateControlPoints(xLocation);
        RenderControlPoints();
        
        stroke(255, 255, 0);
        strokeWeight(10);
        point(xLocation, cValue);
    }

    private void CalculateControlPoints(int xLocation) {
        // From known angle of vector, do some trigonometry to get new x, and y
        float hLength = controlPointStrengthNext * 50;
        float xAcross = cos(controlPointAngle.heading()) * hLength;
        float yDown = sqrt(sq(hLength) - sq(xAcross));

        controlPointPrev.x = xLocation - xAcross;
        controlPointPrev.y = cValue - yDown;

        controlPointNext.x = xLocation + xAcross;
        controlPointNext.y = cValue + yDown;
    }

    private void RenderControlPoints() {
        // Next control point
        strokeWeight(8);
        stroke(255, 0, 0);
        point(controlPointNext.x, controlPointNext.y);

        // Previous control point
        stroke(0, 255, 0);
        point(controlPointPrev.x, controlPointPrev.y);
    }
}