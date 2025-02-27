import { Create, SimpleForm, TextInput, NumberInput, SelectArrayInput, useNotify, useRedirect, required, useGetList, useRefresh, BooleanInput } from 'react-admin';
import axios from 'axios';

const espacioCreate = () => {
    const notify = useNotify();
    const redirect = useRedirect();
    const refresh = useRefresh();

    // Obtener elementos existentes
    const { data: elementos, isLoading } = useGetList('elementos', {
        pagination: { page: 1, perPage: 1000 }
    });

    const handleSubmit = async (data: any) => {
        try {
            const allElements = [
                ...(data.elementos || []),
            ];

            await axios.post('http://localhost:3000/api/espacios', {
                name: data.name,
                quantity: data.quantity,
                elementos: allElements
            });

            notify('Espacio creado exitosamente');
            redirect('/espacios');
            refresh();
        } catch (error) {
            notify('Error al crear espacio', { type: 'error' });
        }
    };

    return (
        <Create title="Crear Nuevo Espacio">
            <SimpleForm onSubmit={handleSubmit} sanitizeEmptyValues>
                <TextInput
                    source="name"
                    label="Nombre del espacio"
                    validate={required()}
                    fullWidth
                />

                <NumberInput
                    source="quantity"
                    label="Cantidad disponible"
                    validate={required()}
                    min={1}
                    fullWidth
                />

                <BooleanInput
                    source="available"
                    label="Disponible"
                    fullWidth
                />

                <SelectArrayInput
                    source="elementos"
                    label="Elementos existentes"
                    choices={elementos || []}
                    optionText="name"
                    optionValue="id"
                    isLoading={isLoading}
                    fullWidth
                />
            </SimpleForm>
        </Create>
    );
};

export default espacioCreate;