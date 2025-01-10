import { useState, useEffect } from 'react';
import axios from 'axios';

const EspaciosList = () => {
    const [espacios, setEspacios] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchEspacios = async () => {
            try {
                const response = await axios.get('http://localhost:3000/api/espacios');
                setEspacios(response.data);
            } catch (error) {
                console.error('Error al cargar los espacios:', error);
            } finally {
                setLoading(false);
            }
        };

        fetchEspacios();
    }, []);

    if (loading) return <div>Cargando espacios...</div>;
    if (!espacios.length) return <div>No hay espacios disponibles.</div>;

    return (
        <div>
            <h1>Lista de Espacios</h1>
            <ul>
                {espacios.map((espacio) => (
                    <li key={espacio._id}>
                        <h2>{espacio.name}</h2>
                        <p>Cantidad: {espacio.quantity}</p>
                        <p>{espacio.available ? 'Disponible' : 'No disponible'}</p>
                        {espacio.elementos && (
                            <ul>
                                {espacio.elementos.map((elemento: any) => (
                                    <li key={elemento._id}>{elemento.name}</li>
                                ))}
                            </ul>
                        )}
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default EspaciosList;