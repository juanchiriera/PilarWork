import { Create, SimpleForm, TextInput, NumberInput, BooleanInput, ArrayInput, SimpleFormIterator } from "react-admin";

const espacioCreate = () => (
    <Create>
        <SimpleForm>
            <TextInput source="name" label="Name" />
            <NumberInput source="quantity" label="Quantity" />
            <BooleanInput source="available" label="Available" />
            <ArrayInput source="elementos" label="Elementos">
                <SimpleFormIterator>
                    <TextInput source="name" label="Element Name" />
                    <NumberInput source="quantity" label="Quantity" />
                    <BooleanInput source="available" label="Available" />
                </SimpleFormIterator>
            </ArrayInput>
        </SimpleForm>
    </Create>
);

export default espacioCreate;