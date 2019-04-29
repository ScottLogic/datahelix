package com.scottlogic.deg.generator.generation.databags;

import com.scottlogic.deg.generator.DataBagValue;
import com.scottlogic.deg.generator.Field;
import com.scottlogic.deg.generator.fieldspecs.FieldSpecSource;
import org.junit.Assert;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import static org.hamcrest.Matchers.equalTo;

class GeneratedObjectTests {
    @Test
    void getShouldReturnSettedValue() {
        // ARRANGE
        Field idField = new Field("id");

        // ACT
        GeneratedObject objectUnderTest = GeneratedObjectBuilder.startBuilding().set(idField, 3, FieldSpecSource.Empty).build();

        // ASSERT
        Assert.assertThat(
            objectUnderTest
                .getFieldToValue()
                .get(idField)
                .getValue(),
            equalTo(3));
    }

    @Test
    void mergedDataBagsShouldContainTheSameValuesAsInputs() {
        // ARRANGE
        Field idField = new Field("id");
        Field priceField = new Field("price");

        GeneratedObject generatedObject1 = GeneratedObjectBuilder.startBuilding().set(idField, new DataBagValue(idField, 3)).build();
        GeneratedObject generatedObject2 = GeneratedObjectBuilder.startBuilding().set(priceField, new DataBagValue(priceField, 4)).build();

        // ACT
        GeneratedObject mergedGeneratedObject = GeneratedObjectMerger.merge(generatedObject1, generatedObject2);

        // ASSERT
        Assert.assertThat(
            mergedGeneratedObject.getFieldToValue().get(idField).getValue(),
            equalTo(3));

        Assert.assertThat(
            mergedGeneratedObject.getFieldToValue().get(priceField).getValue(),
            equalTo(4));
    }

    @Test
    void mergeShouldThrowIfDataBagsOverlap() {
        // ARRANGE
        Field idField = new Field("id");
        Field priceField = new Field("price");

        GeneratedObject generatedObject1 = GeneratedObjectBuilder.startBuilding()
            .set(idField, "foo", FieldSpecSource.Empty)
            .build();

        GeneratedObject generatedObject2 = GeneratedObjectBuilder.startBuilding()
            .set(idField, "foo", FieldSpecSource.Empty)
            .set(priceField, 4, FieldSpecSource.Empty)
            .build();

        // ACT / ASSERT
        Assertions.assertThrows(
            IllegalArgumentException.class,
            () -> GeneratedObjectMerger.merge(generatedObject1, generatedObject2));
    }
}