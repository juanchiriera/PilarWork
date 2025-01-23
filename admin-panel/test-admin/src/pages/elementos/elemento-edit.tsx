import { ArrayInput, BooleanInput, Edit, NumberInput, SimpleForm, SimpleFormIterator, TextInput } from 'react-admin';

const elementoEdit = () => (
    <Edit>
        <SimpleForm>
            <TextInput source="name" />
            <NumberInput source="quantity" />
            <BooleanInput source="available" />
            <ArrayInput source="elementos"><SimpleFormIterator>
<TextInput source="name" />
<NumberInput source="quantity" />
<BooleanInput source="available" />
</SimpleFormIterator></ArrayInput>
        </SimpleForm>
    </Edit>
);

export default elementoEdit;