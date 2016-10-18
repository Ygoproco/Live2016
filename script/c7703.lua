--パワー・ウォール
--Power Wall
--Scripted by Eerie Code
function c7703.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c7703.con)
	e1:SetOperation(c7703.op)
	c:RegisterEffect(e1)
end

function c7703.con(e,tp,eg,ep,ev,re,r,rp)
	local bd=Duel.GetBattleDamage(tp)
	if Duel.GetTurnPlayer()~=tp and bd>0 then
		local dt=math.ceil(bd/500)
		e:SetLabel(dt)
		return Duel.IsPlayerCanDiscardDeckAsCost(tp,dt)
	else
		return false
	end
end
function c7703.op(e,tp,eg,ep,ev,re,r,rp)
	local dt=e:GetLabel()
	if Duel.DiscardDeck(tp,dt,REASON_EFFECT)==dt then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e1:SetOperation(c7703.damop)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e1,tp)
	end
end
function c7703.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end