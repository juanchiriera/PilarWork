import { BooleanField, Create, NumberInput, SimpleForm, TextInput } from "react-admin";

const elementoCreate = () => (
    <Create>
        <SimpleForm>
            <TextInput source="name" label="Nombre" />
            <NumberInput source="quantity" label="Cantidad" />
            <BooleanField source="available" label="Disponible" />
        </SimpleForm>
    </Create>
);

export default elementoCreate;