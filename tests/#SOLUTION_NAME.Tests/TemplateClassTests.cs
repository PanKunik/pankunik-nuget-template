namespace #SOLUTION_NAME.Tests;

public class TemplateClassTests
{
    [Theory]
    [InlineData(1, 1)]
    [InlineData(-1, -1)]
    [InlineData(0, 0)]
    public void TemplateMethod_ForValidInput_ShouldReturnExpectedResult(int inputValue, int expectedValue)
    {
        // Arrange
        var cut = new TemplateClass();

        // Act
        var result = cut.TemplateMethod(inputValue);

        // Assert
        Assert.Equal(expectedValue, result);
    }
}