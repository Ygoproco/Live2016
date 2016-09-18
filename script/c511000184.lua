--Number 14: Greedy Sarameya
function c511000184.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--Trick Battle effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(c511000184.tbcon)
	e1:SetCost(c511000184.tbcost)
	e1:SetOperation(c511000184.tbop)
	c:RegisterEffect(e1)
end
c511000184.xyz_number=14
function c511000184.tbcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttacker()
	if bc==c then bc=Duel.GetAttackTarget() end
	return bc and bc:IsFaceup() and bc:GetAttack()>c:GetAttack()
end
function c511000184.tbcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511000184.tbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttacker()
	if bc==c then
		bc=Duel.GetAttackTarget()
	end
	if bc:GetAttack()>c:GetAttack() then
		local dam=bc:GetAttack()-c:GetAttack()
		Duel.Damage(1-tp,dam,REASON_BATTLE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
		Duel.Destroy(bc,REASON_BATTLE)
	else
		local dam=c:GetAttack()-bc:GetAttack()
		Duel.Damage(1-tp,dam,REASON_BATTLE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		bc:RegisterEffect(e1)
		Duel.Destroy(c,REASON_BATTLE)
	end
	if Duel.IsExistingTarget(c511000184.dfilter,tp,0,LOCATION_MZONE,1,nil,bc:GetAttack()) then
		local g=Duel.SelectMatchingCard(tp,c511000184.dfilter,tp,0,LOCATION_MZONE,1,1,nil,bc:GetAttack())
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c511000184.dfilter(c,atk)
	return c:IsFaceup() and c:IsDestructable() and c:GetAttack()<=atk
end