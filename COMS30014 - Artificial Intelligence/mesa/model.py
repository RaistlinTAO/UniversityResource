from mesa import Model
from agent import FightingAgent
from mesa.time import RandomActivation
from mesa.space import MultiGrid
from mesa.datacollection import DataCollector


class FightingModel(Model):
    """A model with some number of agents."""

    def __init__(self, number_agents, width, height):
        self.num_agents = number_agents
        self.grid = MultiGrid(width, height, False)
        self.schedule = RandomActivation(self)
        self.running = True

        self.datacollector_currents = DataCollector(
            {
                "Healthy Agents": FightingModel.current_healthy_agents,
                "Non Healthy Agents": FightingModel.current_non_healthy_agents,
            }
        )

        # Create agents
        for i in range(self.num_agents):
            a = FightingAgent(i, self, self.random.randrange(4))
            self.schedule.add(a)

            # Add the agent to a random grid cell
            x = self.random.randrange(self.grid.width)
            y = self.random.randrange(self.grid.height)
            self.grid.place_agent(a, (x, y))

    def step(self):
        """Advance the model by one step."""
        self.schedule.step()
        self.datacollector_currents.collect(self)

        # Checking if there is a champion
        if FightingModel.current_healthy_agents(self) == 1:
            self.running = False

    @staticmethod
    def current_healthy_agents(model) -> int:
        """Return the total number of healthy agents

        Args:
            model (FightingModel): The simulation model

        Returns:
            int: Number of healthy agents
        """
        return sum([1 for agent in model.schedule.agents if agent.health > 0])

    @staticmethod
    def current_non_healthy_agents(model) -> int:
        """Return the total number of non healthy agents

        Args:
            model (FightingModel): The simulation model

        Returns:
            int: Number of non healthy agents
        """
        return sum([1 for agent in model.schedule.agents if agent.dead])
