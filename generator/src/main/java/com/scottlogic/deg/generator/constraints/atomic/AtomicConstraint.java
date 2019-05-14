package com.scottlogic.deg.generator.constraints.atomic;

import com.scottlogic.deg.generator.Field;
import com.scottlogic.deg.generator.constraints.Constraint;
import com.scottlogic.deg.generator.inputs.RuleInformation;

import java.util.Collection;
import java.util.Collections;
import java.util.Set;

public interface AtomicConstraint extends Constraint {

    Field getField();

    String toDotLabel();

    default AtomicConstraint negate() {
        return new NotConstraint(this);
    }

    default Collection<Field> getFields() {
        return Collections.singleton(getField());
    }

    AtomicConstraint withRules(Set<RuleInformation> rules);
}
