package com.scottlogic.deg.generator.walker;

import com.scottlogic.deg.generator.DataBagValue;
import com.scottlogic.deg.generator.Field;
import com.scottlogic.deg.generator.Profile;
import com.scottlogic.deg.generator.ProfileFields;
import com.scottlogic.deg.generator.decisiontree.DecisionTree;
import com.scottlogic.deg.generator.decisiontree.NoopDecisionTreeOptimiser;
import com.scottlogic.deg.generator.decisiontree.TreeConstraintNode;
import com.scottlogic.deg.generator.decisiontree.treepartitioning.NoopTreePartitioner;
import com.scottlogic.deg.generator.fieldspecs.FieldSpec;
import com.scottlogic.deg.generator.fieldspecs.FieldSpecSource;
import com.scottlogic.deg.generator.generation.*;
import com.scottlogic.deg.generator.generation.databags.GeneratedObject;
import com.scottlogic.deg.generator.restrictions.NullRestrictions;
import com.scottlogic.deg.generator.restrictions.Nullness;
import com.scottlogic.deg.generator.restrictions.SetRestrictions;
import com.scottlogic.deg.generator.walker.reductive.*;
import com.scottlogic.deg.generator.walker.reductive.fieldselectionstrategy.FixFieldStrategy;
import com.scottlogic.deg.generator.walker.reductive.fieldselectionstrategy.FixFieldStrategyFactory;
import org.junit.Assert;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static org.hamcrest.collection.IsEmptyCollection.empty;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.*;

class ReductiveDataGeneratorTests {
    private TreeConstraintNode rootNode;
    private DecisionTree tree;
    private ReductiveFieldSpecBuilder reductiveFieldSpecBuilder;
    private ReductiveDataGenerator walker;
    private FixFieldStrategy fixFieldStrategy;
    private FixFieldStrategyFactory fixFieldStrategyFactory;
    private FieldSpecValueGenerator fieldSpecValueGenerator;
    private Field field1 = new Field("field1");
    private Field field2 = new Field("field2");

    @BeforeEach
    public void beforeEach(){
        ProfileFields fields = new ProfileFields(Arrays.asList(field1, field2));
        rootNode = new TreeConstraintNode();
        tree = new DecisionTree(rootNode, fields, "");
        ReductiveTreePruner treePruner = mock(ReductiveTreePruner.class);
        when(treePruner.pruneConstraintNode(eq(rootNode), any())).thenReturn(Merged.of(rootNode));

        reductiveFieldSpecBuilder = mock(ReductiveFieldSpecBuilder.class);
        fieldSpecValueGenerator = mock(FieldSpecValueGenerator.class);

        fixFieldStrategy = mock(FixFieldStrategy.class);
        when(fixFieldStrategy.getNextFieldToFix(any(), any())).thenReturn(field1, field2);
        fixFieldStrategyFactory = mock(FixFieldStrategyFactory.class);
        when(fixFieldStrategyFactory.getFixedFieldStrategy(any(), any())).thenReturn(fixFieldStrategy);
        
        GenerationConfig config = new GenerationConfig(new TestGenerationConfigSource(GenerationConfig.DataGenerationType.RANDOM, GenerationConfig.TreeWalkerType.REDUCTIVE, GenerationConfig.CombinationStrategyType.MINIMAL));

        walker = new ReductiveDataGenerator(
            new GeneratorPartitioner(new NoopTreePartitioner(), new NoopDecisionTreeOptimiser(), config),
            new GeneratorRestarter(),
            new NoOpIterationVisualiser(),
            reductiveFieldSpecBuilder,
            new NoopDataGeneratorMonitor(),
            treePruner,
            fieldSpecValueGenerator,
            fixFieldStrategyFactory,
            config);
    }

    /**
     * If no field can be fixed initially, the walker should exit early, with an empty stream of RowSpecs
     */
    @Test
    public void shouldReturnEmptyCollectionOfRowsWhenFirstFieldCannotBeFixed() {
        when(reductiveFieldSpecBuilder.getFieldSpecWithMustContains(eq(rootNode), any())).thenReturn(Optional.empty());

        List<GeneratedObject> result = walker.generateData(mock(Profile.class), tree).collect(Collectors.toList());

        verify(reductiveFieldSpecBuilder).getFieldSpecWithMustContains(eq(rootNode), any());
        Assert.assertThat(result, empty());
    }

    /**
     * If a field can be fixed initially, but subsequently another one cannot be fixed then exit as early as possible
     * with an empty stream of RowSpecs
     */
    @Test
    public void shouldReturnEmptyCollectionOfRowsWhenSecondFieldCannotBeFixed() {
        DataBagValue generatedObject = new DataBagValue(field1, "yes");
        FieldSpec firstFieldSpec = FieldSpec.Empty.withSetRestrictions(SetRestrictions
                .fromWhitelist(Collections.singleton("yes")), FieldSpecSource.Empty)
            .withNullRestrictions(new NullRestrictions(Nullness.MUST_NOT_BE_NULL), FieldSpecSource.Empty);
        when(fieldSpecValueGenerator.generate(any(), any())).thenReturn(Stream.of(generatedObject));

        when(reductiveFieldSpecBuilder.getFieldSpecWithMustContains(any(), any())).thenReturn(Optional.of(firstFieldSpec), Optional.empty());

        List<GeneratedObject> result = walker.generateData(mock(Profile.class), tree).collect(Collectors.toList());;

        verify(reductiveFieldSpecBuilder, times(2)).getFieldSpecWithMustContains(eq(rootNode), any());
        Assert.assertThat(result, empty());
    }
}