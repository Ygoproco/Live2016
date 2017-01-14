--No.32 海咬龍シャーク・ドレイク (Anime)
function c511010032.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3)
	c:EnableReviveLimit()
	--chain attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511010032,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c511010032.atcon)
	e1:SetCost(c511010032.atcost)
	e1:SetTarget(c511010032.attg)
	e1:SetOperation(c511010032.atop)
	c:RegisterEffect(e1)
    --battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c511010032.indes)
	c:RegisterEffect(e2)
	if not c511010032.global_check then
		c511010032.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511010032.numchk)
		Duel.RegisterEffect(ge2,0)
	end
end
c511010032.xyz_number=32
function c511010032.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c==Duel.GetAttacker() and c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) 
		and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c511010032.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511010032.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.GetAttackTarget():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp) end
	Duel.GetAttackTarget():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,Duel.GetAttackTarget(),1,0,0)
end
function c511010032.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	if not bc:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(bc,0,tp,1-tp,false,false,POS_FACEUP_ATTACK) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.ChainAttack(bc)
		end
	end
end
function c511010032.numchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,65676461)
	Duel.CreateToken(1-tp,65676461)
end
function c511010032.indes(e,c)
	return not c:IsSetCard(0x48)
end
