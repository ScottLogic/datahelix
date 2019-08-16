package com.scottlogic.deg.profile.reader.constraintreaders;

import com.scottlogic.deg.common.profile.Field;
import com.scottlogic.deg.common.profile.ProfileFields;
import com.scottlogic.deg.common.profile.constraints.delayed.IsEqualToDynamicDateConstraint;
import com.scottlogic.deg.profile.reader.ConstraintReader;
import com.scottlogic.deg.profile.v0_1.AtomicConstraintType;
import com.scottlogic.deg.profile.v0_1.ConstraintDTO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.threeten.extra.Temporals;

import java.time.temporal.ChronoUnit;
import java.util.Arrays;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.*;

class EqualToFieldReaderTest {

    private static final String FIRST = "first";

    private static final String SECOND = "second";

    private ConstraintReader equalToFieldReader;

    private ProfileFields fields;

    private ConstraintDTO dto;

    @BeforeEach
    public void setUp() {
        equalToFieldReader = new EqualToFieldReader();
        fields = fieldsOf(FIRST, SECOND);
        dto = baseDTO();
    }

    @Test
    public void apply_noOffset_createsTwoEqualFields() {
        IsEqualToDynamicDateConstraint constraint = createConstraint(equalToFieldReader, dto, fields);

        assertEquals(new Field(FIRST), constraint.underlyingConstraint().getField());
        assertEquals(new Field(SECOND), constraint.field());
        assertNull(constraint.unit());
    }

    @Test
    public void apply_withTwoDayOffset_createsTwoFieldsOffset() {
        dto.offset = 2;
        dto.offsetUnit = ChronoUnit.DAYS.toString();

        IsEqualToDynamicDateConstraint constraint = createConstraint(equalToFieldReader, dto, fields);
        assertEquals(2, constraint.offset());
    }

    @Test
    public void apply_withWorkingDayOffset_createsTwoFieldsWithWorkingDayOffset() {
        dto.offset = 5;
        dto.offsetUnit = "WORKING DAYS";

        IsEqualToDynamicDateConstraint constraint = createConstraint(equalToFieldReader, dto, fields);

        assertEquals(Temporals.nextWorkingDay(), constraint.unit().adjuster());
    }

    private static ConstraintDTO baseDTO() {
        ConstraintDTO dto = new ConstraintDTO();
        dto.field = FIRST;
        dto.is = AtomicConstraintType.IS_EQUAL_TO_FIELD.getText();
        dto.value = SECOND;
        return dto;
    }

    private static ProfileFields fieldsOf(String... fields) {
        return new ProfileFields(
            Arrays.stream(fields)
                .map(Field::new)
                .collect(Collectors.toList()));
    }

    private static IsEqualToDynamicDateConstraint createConstraint(ConstraintReader reader,
                                                                   ConstraintDTO dto,
                                                                   ProfileFields fields) {
        return (IsEqualToDynamicDateConstraint) reader.apply(dto, fields);
    }
}